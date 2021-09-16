//
//  CountUpModel.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/15.
//

import UIKit

protocol CountUpModelProtocol {
    func countUp(count: Int) -> Int
    func countDown(count: Int) -> Int
    func checkState(level: Int) -> (String, UIImage?)
}

final class CountUpModel: CountUpModelProtocol {
    func countUp(count: Int) -> Int {
        return count + 1
    }

    func countDown(count: Int) -> Int {
        if count > 0 {
            return count - 1
        }
        return count
    }

    func checkState(level: Int) -> (String, UIImage?) {
        switch level {
        case 0 ..< 15:
            return ("ヒトカゲ", UIImage(named: "hitokage"))
        case 15 ..< 30:
            return ("リザード", UIImage(named: "rizard"))
        case 30...:
            return ("リザードン", UIImage(named: "rizardon"))
        default:
            return ("", nil)
        }
    }

}
