//
//  CountUpViewController.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CountUpViewController: UIViewController {

    @IBOutlet private weak var monsterImageView: UIImageView! {
        didSet {
            monsterImageView.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var countUpButton: UIButton! {
        didSet {
            countUpButton.layer.cornerRadius = 10
        }
    }

    @IBOutlet private weak var countDownButton: UIButton! {
        didSet {
            countDownButton.layer.cornerRadius = 10
        }
    }

    private let disposeBag = DisposeBag()
    private let viewModel = CountUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

}

private extension CountUpViewController {
    func bind() {
        //ボタンがタップされたことをviewModelに通知する
        countUpButton.rx.tap
            .subscribe { [weak self] _ in
                //viewModelの更新を受け取る
                self?.viewModel.countUp()

            }
            .disposed(by: disposeBag)

        countDownButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.countDown()
            }
            .disposed(by: disposeBag)

        viewModel.count.asObservable()
            .subscribe { [weak self] count in
                self?.levelLabel.text = String(count)
            }
            .disposed(by: disposeBag)

        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                self?.stateLabel.text = state
            })
            .disposed(by: disposeBag)

        viewModel.image.asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.monsterImageView.image = image
            })
            .disposed(by: disposeBag)

    }
}
