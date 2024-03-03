//
//  EpisodesListViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol EpisodesListViewModelType {
    var content: Driver<[EpisodeContent]> { get }
    var seasonSelectedTitle: Driver<String?> { get }
    var showSeasons: Driver<[PickerItem]> { get }
    var selectedItem: Driver<EpisodeContent?> { get }
    
    func bindSeasonPress(observable: Observable<Void>) -> Disposable
    func bindSeasonSelected(observable: Observable<PickerItem?>) -> Disposable
    func bindSelectedItem(observable: Observable<EpisodeContent>) -> Disposable
}

struct EpisodesListViewModel: EpisodesListViewModelType {
    private let contentRelay: BehaviorRelay<[EpisodeContent]>
    private let seasonSelectedRelay: BehaviorRelay<Int>
    private let showSeasonsRelay: PublishRelay<Void>
    private let selectItemRelay: PublishRelay<EpisodeContent?>
    
    init(episodes: [EpisodeContent]) {
        contentRelay = BehaviorRelay(value: episodes)
        seasonSelectedRelay = BehaviorRelay(value: episodes.first?.season ?? 0)
        showSeasonsRelay = PublishRelay()
        selectItemRelay = PublishRelay()
    }
    
    var content: Driver<[EpisodeContent]> {
        Observable.combineLatest(contentRelay, seasonSelectedRelay)
            .map { content, seasonSelected in
                content.filter { $0.season == seasonSelected }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var seasonSelectedTitle: Driver<String?> {
        seasonSelectedRelay
            .map { "Season \($0)" }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var showSeasons: Driver<[PickerItem]> {
        showSeasonsRelay
            .map { _ in self.contentRelay.value }
            .map { value in
                let seasons = Set(value.map { $0.season ?? 0 }).sorted()
                return seasons.map { PickerItem(key: String($0), title: "Season \($0)") }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var selectedItem: Driver<EpisodeContent?> {
        selectItemRelay.asDriver(onErrorJustReturn: nil)
    }
    
    func bindSeasonPress(observable: Observable<Void>) -> Disposable {
        observable.bind(to: showSeasonsRelay)
    }
    
    func bindSeasonSelected(observable: Observable<PickerItem?>) -> Disposable {
        observable
            .compactMap { $0 }
            .map { Int($0.key) }
            .compactMap { $0 }
            .bind(to: seasonSelectedRelay)
    }
    
    func bindSelectedItem(observable: Observable<EpisodeContent>) -> Disposable {
        observable.bind(to: selectItemRelay)
    }
}
