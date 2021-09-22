//
//  SliderChangeViewController.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/20.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        value = 1
        minimumValue = 0
        maximumValue = 1
    }

//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        return true
//    }
}

final class SliderChangeViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private weak var alphaLabel: UILabel!
    @IBOutlet private weak var redLabel: UILabel!
    @IBOutlet private weak var greenLabel: UILabel!
    @IBOutlet private weak var blueLabel: UILabel!
    @IBOutlet private weak var hexCodeLabel: UILabel!


    @IBOutlet private weak var alphaSlider: CustomSlider! {
        didSet {
            alphaSlider.minimumTrackTintColor = .darkGray
            alphaSlider.maximumTrackTintColor = .lightGray
        }
    }

    @IBOutlet private weak var redSlider: CustomSlider! {
        didSet {
            redSlider.thumbTintColor = .systemRed
            redSlider.minimumTrackTintColor = .systemRed
            redSlider.maximumTrackTintColor = .lightGray
        }
    }

    @IBOutlet private weak var greenSlider: CustomSlider! {
        didSet {
            greenSlider.thumbTintColor = .systemGreen
            greenSlider.minimumTrackTintColor = .systemGreen
            greenSlider.maximumTrackTintColor = .lightGray
        }
    }
    @IBOutlet private weak var blueSlider: CustomSlider! {
        didSet {
            blueSlider.thumbTintColor = .systemBlue
            blueSlider.minimumTrackTintColor = .systemBlue
            blueSlider.maximumTrackTintColor = .lightGray
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

}

private extension SliderChangeViewController {
    func bind() {
        //観測対象にする
        let alphaObservable: Observable<CGFloat> = alphaSlider.rx.value
            .map({CGFloat($0) * 100})
        let redObservable: Observable<CGFloat> = redSlider.rx.value
            .map({CGFloat($0)})
        let greenObservable: Observable<CGFloat> = greenSlider.rx.value
            .map({CGFloat($0)})
        let blueObservable: Observable<CGFloat> = blueSlider.rx.value
            .map({CGFloat($0)})
        ///上記の値の最新値を結合する
        let color: Observable<UIColor> = Observable<UIColor>.combineLatest(redObservable, greenObservable, blueObservable, alphaObservable) { (redValue, greenValue, blueValue, alpha) -> UIColor in
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }

        let hex: Observable<String> = Observable<String>.combineLatest(redObservable, greenObservable, blueObservable, alphaObservable) { (redValue, greenValue, blueValue, alpha) -> String in
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha).hex(withHash: true)
        }

        //イベントプロパティをバインドして、完了したら開放するようにする
        alphaObservable
            .map({"\(round($0) / 100)"})
            .bind(to: alphaLabel.rx.text)
            .disposed(by: disposeBag)

        redObservable
            .map({"\(Int($0 * 255))"})
            .bind(to: redLabel.rx.text)
            .disposed(by: disposeBag)

        greenObservable
            .map({"\(Int($0 * 255))"})
            .bind(to: greenLabel.rx.text)
            .disposed(by: disposeBag)

        blueObservable
            .map({"\(Int($0 * 255))"})
            .bind(to: blueLabel.rx.text)
            .disposed(by: disposeBag)

        color.bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)

        hex.bind(to: hexCodeLabel.rx.text)
            .disposed(by: disposeBag)

    }
}
