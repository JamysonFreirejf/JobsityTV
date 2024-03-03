//
//  SearchPeopleViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

struct SearchPeopleViewModel: SearchViewModelType {
    let backRelay: PublishRelay<Void>
    let contentRelay: BehaviorRelay<[ShowSearchData]>
    let selectItemRelay: PublishRelay<ShowSearchData?>
    
    private let repository: SearchShowRepository
    
    init(repository: SearchShowRepository = SearchPeopleRemoteRepository()) {
        self.repository = repository
        backRelay = PublishRelay()
        contentRelay = BehaviorRelay(value: [])
        selectItemRelay = PublishRelay()
    }
    
    func bindInput(observable: Observable<String>) -> Disposable {
        throttleInput(observable: observable)
            .flatMap { value -> Observable<[SearchPeople]> in
                if value.isEmpty {
                    return .just([])
                }
                return self.repository.fetch(query: value)
            }
            .map { value in
                value.compactMap { ShowSearchData(id: $0.person?.id,
                                                  title: $0.person?.name,
                                                  image: $0.person?.image?.original)
                    }
            }
            .bind(to: contentRelay)
    }
}
