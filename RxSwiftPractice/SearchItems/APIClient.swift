//
//  APIClient.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/16.
//

import Foundation
import RxSwift


protocol APIClientProtocol {
    func search(from word: String) -> Observable<[QiitaItemModel]>
}

final class APIClient: APIClientProtocol {

    private let host = URL(string: "https://qiita.com/api/v2/items")!

    func search(from word: String) -> Observable<[QiitaItemModel]> {
        //URLの構築
        var urlComponents = URLComponents(url: host,
                                          resolvingAgainstBaseURL: false)!
        let queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "query", value: word)
        ]
        urlComponents.queryItems = queryItems
        //Requestの作成
        let request = URLRequest(url: urlComponents.url!)
        //[QiitaItemsModel]のObservableを返す
        return URLSession.shared.rx.response(request: request)
            .map { pair in
                do {
                    let items = try JSONDecoder().decode([QiitaItemModel].self, from: pair.data)
                    return items
                } catch {
                    throw error
                }
            }
    }

    
}
