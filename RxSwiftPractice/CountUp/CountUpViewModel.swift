//
//  CountUpViewModel.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/15.
//

import UIKit
import RxSwift

final class CountUpViewModel {

    private let countSubject = PublishSubject<Int>()
    private let stateSubject = PublishSubject<String>()
    private let imageSubject = PublishSubject<UIImage>()

    //公開するObservable
    var count: Observable<Int> {
        return countSubject
    }

    var state: Observable<String> {
        return stateSubject
    }

    var image: Observable<UIImage> {
        return imageSubject
    }

    private var number = 0

    func countUp() {
        number += 1
        countSubject.onNext(number)
        stateSubject.onNext(stateText())
        guard let image = stateImage() else { return }
        imageSubject.onNext(image)
    }

    func countDown() {
        if number > 0 {
            number -= 1
            countSubject.onNext(number)
            stateSubject.onNext(stateText())
            guard let image = stateImage() else { return }
            imageSubject.onNext(image)
        }
    }

    func stateText() -> String {
        switch number {
        case 0 ..< 15:
            return "ヒトカゲ"
        case 15 ..< 30:
            return "リザード"
        case 30...:
            return "リザードン"
        default:
            return ""
        }
    }

    func stateImage() -> UIImage? {
        switch number {
        case 0 ..< 15:
            return UIImage(named: "hitokage")
        case 15 ..< 30:
            return UIImage(named: "rizard")
        case 30...:
            return UIImage(named: "rizardon")
        default:
            return nil
        }
    }


}
