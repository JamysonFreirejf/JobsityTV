//
//  HomeViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol HomeViewModelType {
    var content: Driver<[ShowSearchData]> { get }
    var selectedItem: Driver<Show?> { get }
    
    func bindFetch() -> Disposable
    func bindPrefetch(observable: Observable<[IndexPath]>) -> Disposable
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable
}

struct HomeViewModel: HomeViewModelType {
    private let repository: HomeRepository
    private let pageRelay: BehaviorRelay<Int>
    private let contentRelay: BehaviorRelay<[Show]>
    private let showDetailsRelay: PublishRelay<Show?>
    
    init(repository: HomeRepository = HomeRemoteRepository()) {
        self.repository = repository
        pageRelay = BehaviorRelay(value: 0)
        contentRelay = BehaviorRelay(value: [])
        showDetailsRelay = PublishRelay()
    }
    
    var content: Driver<[ShowSearchData]> {
        contentRelay
            .map { value in
                value.map {
                    ShowSearchData(id: $0.id, title: $0.name, image: $0.image?.original)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var selectedItem: Driver<Show?> {
        showDetailsRelay.asDriver(onErrorJustReturn: nil)
    }
    
    func bindFetch() -> Disposable {
        pageRelay
            .flatMap { self.repository.fetch(at: $0) }
            .catch { error in
                //catch if network error or similar and stream to error observable
                .just([])
            }
            .map { self.contentRelay.value + $0 }
            .bind(to: contentRelay)
    }
    
    func bindPrefetch(observable: Observable<[IndexPath]>) -> Disposable {
        observable
            .map { $0.last?.item ?? 0 }
            .distinctUntilChanged()
            .filter { $0 == self.contentRelay.value.count - 1 }
            .map { _ in self.pageRelay.value + 1 }
            .bind(to: pageRelay)
    }
    
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable {
        observable
            .map { value in
                self.contentRelay.value.filter { $0.id == value.id }.last
            }
            .bind(to: showDetailsRelay)
    }
}
