//
//  FavoritesViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol FavoritesViewModelType {
    var content: Driver<[ShowSearchData]> { get }
    var isAlphabeticalActive: Driver<Bool> { get }
    var selectedItem: Driver<Show?> { get }
    
    func bindFetch() -> Disposable
    func bindAlphabeticalSlider(observable: Observable<Bool>) -> Disposable
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable
}

struct FavoritesViewModel: FavoritesViewModelType {
    private let repository: FavoritesRepository
    private let contentRelay: BehaviorRelay<[Show]>
    private let alphabeticalRelay: BehaviorRelay<Bool>
    private let selectedItemRelay: PublishRelay<Show?>
    
    init(repository: FavoritesRepository = FavoritesLocalRepository()) {
        self.repository = repository
        contentRelay = BehaviorRelay(value: [])
        alphabeticalRelay = BehaviorRelay(value: false)
        selectedItemRelay = PublishRelay()
    }
    
    var content: Driver<[ShowSearchData]> {
        Observable.combineLatest(contentRelay, alphabeticalRelay)
            .map { content, isAlphabetical -> [Show] in
                if isAlphabetical {
                    return content.sorted { old, new in
                        old.name < new.name
                    }
                }
                return content
            }
            .map { value in
                value.map {
                    ShowSearchData(id: $0.id, title: $0.name, image: $0.image?.original)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var isAlphabeticalActive: Driver<Bool> {
        alphabeticalRelay.asDriver()
    }
    
    var selectedItem: Driver<Show?> {
        selectedItemRelay.asDriver(onErrorJustReturn: nil)
    }
    
    func bindFetch() -> Disposable {
        repository.fetch()
            .bind(to: contentRelay)
    }
    
    func bindAlphabeticalSlider(observable: Observable<Bool>) -> Disposable {
        observable.bind(to: alphabeticalRelay)
    }
    
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable {
        observable
            .map { value in
                self.contentRelay.value.filter { $0.id == value.id }.last
            }
            .bind(to: selectedItemRelay)
    }
}
