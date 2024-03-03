//
//  SearchViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol SearchViewModelType {
    var backRelay: PublishRelay<Void> { get }
    var contentRelay: BehaviorRelay<[ShowSearchData]> { get }
    var selectItemRelay: PublishRelay<ShowSearchData?> { get }
    
    var backPressed: Driver<Void> { get }
    var content: Driver<[ShowSearchData]> { get }
    var selectedItem: Driver<Int?> { get }
    
    func bindBack(observable: Observable<Void>) -> Disposable
    func bindInput(observable: Observable<String>) -> Disposable
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable
}

extension SearchViewModelType {
    func throttleInput(observable: Observable<String>) -> Observable<String> {
        observable
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
}

extension SearchViewModelType {
    var backPressed: Driver<Void> {
        backRelay.asDriver(onErrorJustReturn: ())
    }
    
    var content: Driver<[ShowSearchData]> {
        contentRelay.asDriver(onErrorJustReturn: [])
    }
    
    var selectedItem: Driver<Int?> {
        selectItemRelay
            .map { $0?.id }
            .asDriver(onErrorJustReturn: nil)
    }
    
    func bindBack(observable: Observable<Void>) -> Disposable {
        observable.bind(to: backRelay)
    }
    
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable {
        observable
            .bind(to: selectItemRelay)
    }
}
