//
//  MainViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol MainViewModelType {
    var searchPressed: Driver<Void> { get }
    var showSettingsPressed: Driver<Void> { get }
    
    func bindSearch(observable: Observable<Void>) -> Disposable
    func bindSettings(observable: Observable<Void>) -> Disposable
}

struct MainViewModel: MainViewModelType {
    private let showSearchRelay: PublishRelay<Void>
    private let showSettingsRelay: PublishRelay<Void>
    
    init() {
        showSearchRelay = PublishRelay()
        showSettingsRelay = PublishRelay()
    }
    
    var searchPressed: Driver<Void> {
        showSearchRelay.asDriver(onErrorJustReturn: ())
    }
    
    var showSettingsPressed: Driver<Void> {
        showSettingsRelay.asDriver(onErrorJustReturn: ())
    }
    
    func bindSearch(observable: Observable<Void>) -> Disposable {
        observable.bind(to: showSearchRelay)
    }
    
    func bindSettings(observable: Observable<Void>) -> Disposable {
        observable.bind(to: showSettingsRelay)
    }
}
