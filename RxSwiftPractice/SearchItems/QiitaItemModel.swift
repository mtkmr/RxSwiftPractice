//
//  GithubSearchResponse.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/16.
//

import Foundation

struct QiitaItemModel: Decodable {
    var title: String
    var url: String
    var user: QiitaUser

    //どうせURLを返すので変換しておく
    var urlConverted: URL { return URL(string: url)! }
}

struct QiitaUser: Decodable {
    var name: String
}
