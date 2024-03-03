//
//  SearchTVShowsViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

struct SearchTVShowsViewModel: SearchViewModelType {
    let backRelay: PublishRelay<Void>
    let contentRelay: BehaviorRelay<[ShowSearchData]>
    let selectItemRelay: PublishRelay<ShowSearchData?>
    
    private let repository: SearchShowRepository
    
    init(repository: SearchShowRepository = SearchShowRemoteRepository()) {
        self.repository = repository
        backRelay = PublishRelay()
        contentRelay = BehaviorRelay(value: [])
        selectItemRelay = PublishRelay()
    }
    
    func bindInput(observable: Observable<String>) -> Disposable {
        throttleInput(observable: observable)
            .flatMap { value -> Observable<[SearchShow]> in
                if value.isEmpty {
                    return .just([])
                }
                return self.repository.fetch(query: value)
            }
            .map { value in
                value.compactMap { ShowSearchData(id: $0.show?.id,
                                                  title: $0.show?.name,
                                                  image: $0.show?.image?.original)
                    }
            }
            .bind(to: contentRelay)
    }
}
