//
//  TimerViewController.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/21.
//

import UIKit
import RxSwift
import RxCocoa

final class StopWatchViewController: UIViewController {

    @IBOutlet private weak var timerLabel: UILabel! {
        didSet {
            timerLabel.font = UIFont.monospacedDigitSystemFont(
                ofSize: 60,
                weight: .light
            )
        }
    }
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(
                UINib(
                    nibName: StopWatchTableViewCell.className,
                    bundle: nil
                ),
                forCellReuseIdentifier: StopWatchTableViewCell.className
            )
        }
    }

    //ViewModelに依存
    private var viewModel: StopWatchViewModel!

    //処理完了したら解放するため
    private let disposeBag = RxSwift.DisposeBag()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        title = "ストップウォッチ"
        setupViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetButton.layer.cornerRadius = resetButton.frame.size.height / 2
        startButton.layer.cornerRadius = startButton.frame.size.height / 2
    }
    
}

private extension StopWatchViewController {

    func setupViewModel() {
        viewModel = StopWatchViewModel(input: self)

        //viewModelから通知が来たときの処理を宣言しておく
        //ボタンの見た目を変更
        viewModel.isRunningObservable
            .bind { [weak self] isRunning in
                self?.updateStartButton(isRunning)
            }
            .disposed(by: disposeBag)

        //ラベルを変更
        viewModel.secondsObservable
            .map {
                String(format: "%02d:%02d:%02d",
                       $0 / 100 / 60, $0 / 100 % 60, $0 % 100)
            }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)

    }

    func updateStartButton(_ isRunning: Bool) {
        if isRunning {
            startButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            startButton.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
            startButton.setTitle("停止", for: .normal)
            resetButton.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

        } else {
            startButton.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.5607843137, blue: 0, alpha: 1)
            startButton.setTitleColor(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1), for: .normal)
            startButton.setTitle("開始", for: .normal)
            resetButton.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        }
    }
}

//MARK: - StopWatchViewModelInput
//ViewModelに通知する (流入するObservableパラメータ)
//UIイベントをObservableに変換したもの？
extension StopWatchViewController: StopWatchViewModelInput {
    var startButtonObservable: Observable<Void> {
        startButton.rx.tap.asObservable()
    }

    var resetButtonObservable: Observable<Void> {
        resetButton.rx.tap.asObservable()
    }
}

extension StopWatchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension StopWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StopWatchTableViewCell.className,
            for: indexPath
        ) as! StopWatchTableViewCell
        cell.backgroundColor = .black
        cell.contentView.backgroundColor = .black
//        cell.configure(
//            title: "ラップ\(indexPath.row)",
//            time: "00:00:00"
//        )

        return cell
    }


}
