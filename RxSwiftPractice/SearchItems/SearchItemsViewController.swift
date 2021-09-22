//
//  GithubSearchViewController.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/16.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

final class SearchItemsViewController: UIViewController {

    private var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            //tableViewCellを登録
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }

    //自動disposeのため
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar
        setupSearchBar()

        //viewModelを参照する
        let viewModel = SearchItemsViewModel(
            searchWord: searchBar.rx.text.orEmpty.asObservable(),
            api: APIClient()
        )

        //viewModelを介してtableViewCellをバインドする
        viewModel.searchItems
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) {
                row, item, cell in
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.user.name
            }
            .disposed(by: disposeBag)

        //viewModelを介してtitleを更新
        viewModel.searchItems
            .observe(on: MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.title = String(items.count)
            })
            .disposed(by: disposeBag)

        //tableViewCellが選択されたときにバインドする
        //.asDriverでメインスレッドで通知する
        tableView.rx.modelSelected(QiitaItemModel.self)
            .asDriver()
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }

                let safariVC = SFSafariViewController(url: item.urlConverted)
                self.present(safariVC, animated: true, completion: nil)

            })
            .disposed(by: disposeBag)
    }
    
}

private extension SearchItemsViewController {
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "キーワードを入力"
//        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        //        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}
