//
//  ShowPeopleDetailsViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol ShowPeopleDetailsViewModelType {
    var title: Driver<String?> { get }
    var posterURL: Driver<URL?> { get }
    var castCreditsContent: Driver<[ShowSearchData]> { get }
    var selectItem: Driver<Int?> { get }
    
    func bindFetch() -> Disposable
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable
}

struct ShowPeopleDetailsViewModel: ShowPeopleDetailsViewModelType {
    private let repository: ShowPeopleDetailsRepository
    private let peopleContentIdRelay: BehaviorRelay<Int?>
    private let personContentRelay: BehaviorRelay<PeopleDetailsContent?>
    private let selectItemRelay: PublishRelay<Int?>
    
    init(repository: ShowPeopleDetailsRepository = ShowPeopleDetailsRemoteRepository(),
         peopleContentId: Int?) {
        self.repository = repository
        peopleContentIdRelay = BehaviorRelay(value: peopleContentId)
        personContentRelay = BehaviorRelay(value: nil)
        selectItemRelay = PublishRelay()
    }
    
    var title: Driver<String?> {
        personContentRelay
            .map { $0?.peopleContent }
            .map { $0?.name }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var posterURL: Driver<URL?> {
        personContentRelay
            .map { $0?.peopleContent }
            .map { $0?.image?.original ?? "" }
            .map { URL(string: $0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var castCreditsContent: Driver<[ShowSearchData]> {
        personContentRelay
            .map { $0?.castCredits ?? [] }
            .map { value in
                value.map {
                    ShowSearchData(id: $0.embeded?.show?.id,
                                   title: $0.embeded?.show?.name,
                                   image: $0.embeded?.show?.image?.original)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var selectItem: Driver<Int?> {
        selectItemRelay.asDriver(onErrorJustReturn: nil)
    }
    
    func bindFetch() -> Disposable {
        peopleContentIdRelay
            .compactMap { $0 }
            .flatMap {
                self.repository.fetch(id: $0)
            }
            .bind(to: personContentRelay)
    }
    
    func bindSelectedItem(observable: Observable<ShowSearchData>) -> Disposable {
        observable
            .map { $0.id }
            .compactMap { $0 }
            .bind(to: selectItemRelay)
    }
}
