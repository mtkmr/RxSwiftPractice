//
//  GithubSearchViewModel.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/16.
//

import RxSwift
import RxRelay

final class SearchItemsViewModel {
    let searchItems: Observable<[QiitaItemModel]>
    let error: Observable<Error>

    init(searchWord: Observable<String>, api: APIClientProtocol) {

        //オペレータで制限して通信する
        //filterで2文字以下のときは通信しない
        //debounceで1秒経ったときに最新のイベントを流す
        //distinctUntilChangedで連続して同じ値は流さない
        //flatMapLatestで最新の処理結果を得る
        //materializeでsearchの結果をObservableのEventでラップして返す
        //最後に何度もObservableを生成しないようにshareしておく
        let results = searchWord
            .filter{ 3 <= $0.count }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest{
                return api.search(from: $0).materialize()
            }
            .share(replay: 1)

        //flatMapでObservable<Event<[GithubItem]>>⇨Observable<[GithubItem]>
        //justは単一のObservableを流す
        //[QiitaItemModel]のObservableを流す
        searchItems = results
            .flatMap {
                $0.element.map(Observable.just) ?? .empty()
            }

        //同様にerrorのObeservableを流す
        error = results
            .flatMap {
                $0.error.map(Observable.just) ?? .empty()
            }
    }
}
