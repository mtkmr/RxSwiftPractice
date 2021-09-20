//
//  UIColor+.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/20.
//

import UIKit

extension UIColor {
    ///16進数カラーコードを生成する
    func hex(withHash hash: Bool = false, uppercase up: Bool = false) -> String {
        if let components = self.cgColor.components {
            let r = ("0" + String(Int(components[0] * 255.0), radix: 16, uppercase: up)).suffix(2)
            let g = ("0" + String(Int(components[1] * 255.0), radix: 16, uppercase: up)).suffix(2)
            let b = ("0" + String(Int(components[2] * 255.0), radix: 16, uppercase: up)).suffix(2)
            return (hash ? "#" : "") + String(r + g + b)
        }
        return "000000"
    }
}
