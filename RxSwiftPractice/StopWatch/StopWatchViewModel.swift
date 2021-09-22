//
//  TimerViewModel.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/21.
//

import RxSwift
import RxCocoa
import RxRelay

//viewModelの入力に関するprotocol
protocol StopWatchViewModelInput {
    //バインドの入口　Observableを公開する
    var startButtonObservable: Observable<Void> { get }
    var resetButtonObservable: Observable<Void> { get }

}

//viewModelの出力に関するprotocol
//ここでは、Observableを公開
protocol StopWatchViewModelOutput {
    var isRunningObservable: Observable<Bool> { get }
    var secondsObservable: Observable<Int> { get }

}

final class StopWatchViewModel: StopWatchViewModelOutput {
    //処理完了したら解放するため
    private let disposeBag = RxSwift.DisposeBag()

    //出力側の典型的な書き方
    //公開するのはObservableに変換したもの
    private let _isRunning: BehaviorRelay<Bool> = .init(value: false)
    lazy var isRunningObservable: Observable<Bool> = _isRunning.asObservable()
    private let _seconds: BehaviorRelay<Int> = .init(value: 0)
    lazy var secondsObservable: Observable<Int> = _seconds.asObservable()

    //初期化時に、流すストリームを宣言してしまう
    init(input: StopWatchViewModelInput) {

        let startButtonObservable = input.startButtonObservable
        let resetButtonObservable = input.resetButtonObservable

        //startButtonが押されたら、_isRunningに反転したフラグを流す
        startButtonObservable
            .map { _ in
                !self._isRunning.value
            }
            .bind(to: _isRunning)
            .disposed(by: disposeBag)

        //ここで宣言するべきかどうか考える必要あり
        //_isRunningに判定値が流れてきたら、それによって数値を_secondsに流す
        _isRunning
            .flatMapLatest({ isRunning -> Observable<Int> in
                if isRunning {
                    return Observable<Int>.interval(RxTimeInterval.milliseconds(10), scheduler: MainScheduler.instance)
                } else {
                    return Observable<Int>.empty()
                }
            })
            .bind(onNext: { [weak self] seconds in
                guard let strongSelf = self else { return }
                strongSelf._seconds.accept(strongSelf._seconds.value + 1)
            })
            .disposed(by: disposeBag)

        //resetButtonが押されたとき、
        //_secondsに0を流す
        resetButtonObservable
            .map { 0 }
            .bind(to: _seconds)
            .disposed(by: disposeBag)
        //_isRunningにfalseを流す
        resetButtonObservable
            .map { false }
            .bind(to: _isRunning)
            .disposed(by: disposeBag)
    }

}
