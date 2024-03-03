//
//  SearchOptionsViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol SearchOptionsViewModelType {
    var options: Driver<[SearchOption]> { get }
    var selectedContent: Driver<SearchOption?> { get }
    
    func bindSelectedContent(observable: Observable<SearchOption>) -> Disposable
}

struct SearchOptionsViewModel: SearchOptionsViewModelType {
    private let optionsRelay: BehaviorRelay<[SearchOption]>
    private let selectedContentRelay: PublishRelay<SearchOption?>
    
    init() {
        optionsRelay = BehaviorRelay(value: [.tvShows, .people])
        selectedContentRelay = PublishRelay()
    }
    
    var options: Driver<[SearchOption]> {
        optionsRelay.asDriver()
    }
    
    var selectedContent: Driver<SearchOption?> {
        selectedContentRelay.asDriver(onErrorJustReturn: nil)
    }
    
    func bindSelectedContent(observable: Observable<SearchOption>) -> Disposable {
        observable.bind(to: selectedContentRelay)
    }
}
