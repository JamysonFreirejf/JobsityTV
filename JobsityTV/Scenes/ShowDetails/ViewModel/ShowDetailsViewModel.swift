//
//  ShowDetailsViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol ShowDetailsViewModelType {
    var banners: Driver<[ImageFullContent]> { get }
    var posterURL: Driver<URL?> { get }
    var title: Driver<String?> { get }
    var summary: Driver<String?> { get }
    var subTitle: Driver<String?> { get }
    var genre: Driver<String?> { get }
    var stars: Driver<String?> { get }
    var scheduleTime: Driver<String?> { get }
    var averageTime: Driver<String?> { get }
    var episodesCount: Driver<String?> { get }
    var episodesListPressed: Driver<[EpisodeContent]> { get }
    var favoriteImage: Driver<UIImage?> { get }
    
    func bindContent() -> Disposable
    func bindShowEpisodesList(observable: Observable<Void>) -> Disposable
    func bindFavorites() -> Disposable 
    func bindSelectedFavorite(observable: Observable<Void>) -> Disposable 
}

struct ShowDetailsViewModel: ShowDetailsViewModelType {
    private let repository: ShowDetailsRemoteRepository
    private let favoritesRepository: FavoritesRepository
    private let contentIdRelay: BehaviorRelay<Int>
    private let contentRelay: BehaviorRelay<ShowDetailsContent?>
    private let showEpisodesListRelay: PublishRelay<Void>
    private let favoriteRelay: PublishRelay<Bool>
    
    init(repository: ShowDetailsRemoteRepository = ShowDetailsRemoteRepository(),
         favoritesRepository: FavoritesRepository = FavoritesLocalRepository(),
         contentId: Int) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
        contentIdRelay = BehaviorRelay(value: contentId)
        contentRelay = BehaviorRelay(value: nil)
        showEpisodesListRelay = PublishRelay()
        favoriteRelay = PublishRelay()
    }
    
    var banners: Driver<[ImageFullContent]> {
        contentRelay
            .map { $0?.images ?? [] }
            .map { value in
                value.filter { $0.isBackground }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    var posterURL: Driver<URL?> {
        contentRelay
            .map { $0?.show?.image?.original ?? "" }
            .map { URL(string: $0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var title: Driver<String?> {
        contentRelay
            .map { $0?.show?.name }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var summary: Driver<String?> {
        contentRelay
            .map { $0?.show?.summary?.removingHTMLTags()}
            .asDriver(onErrorJustReturn: nil)
    }
    
    var subTitle: Driver<String?> {
        contentRelay
            .map {
                let premiered = $0?.show?.premiered ?? ""
                let ended = $0?.show?.ended ?? ""
                let status = $0?.show?.status ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let datePremiered = dateFormatter.date(from: premiered), !status.isEmpty {
                    let yearPremired = Calendar.current.component(.year, from: datePremiered)
                    if let dateEnded = dateFormatter.date(from: ended) {
                        let yearEnded = Calendar.current.component(.year, from: dateEnded)
                        return "\(yearPremired) - \(yearEnded) | \(status)"
                    }
                    
                    return "\(yearPremired) | \(status)"
                }
                
                return status
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var stars: Driver<String?> {
        contentRelay
            .map { $0?.show?.rating?.average ?? 0 }
            .map { String($0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var scheduleTime: Driver<String?> {
        contentRelay
            .map { $0?.show?.schedule }
            .map {
                let days = $0?.days
                let daysStr = days.map { $0.joined(separator: ", ") } ?? ""
                let time = $0?.time ?? ""
                return "\(daysStr) | \(time)"
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var averageTime: Driver<String?> {
        contentRelay
            .map { $0?.show?.averageRuntime ?? 0 }
            .map { String($0) }
            .map { "\($0) min" }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var genre: Driver<String?> {
        contentRelay
            .map { $0?.show?.genres }
            .map { $0?.joined(separator: ", ") }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var episodesCount: Driver<String?> {
        contentRelay
            .map { $0?.episodes?.count ?? 0 }
            .map { String($0) }
            .map { 
                if $0.isEmpty { return nil }
                return "\($0) Episodes"
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var episodesListPressed: Driver<[EpisodeContent]> {
        showEpisodesListRelay
            .map { _ in self.contentRelay.value?.episodes ?? [] }
            .asDriver(onErrorJustReturn: [])
    }
    
    var favoriteImage: Driver<UIImage?> {
        favoriteRelay
            .map {
                UIImage(systemName: $0 ? "heart.fill" : "heart")
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    func bindContent() -> Disposable {
        contentIdRelay
            .flatMap { self.repository.fetch(id: $0) }
            .bind(to: contentRelay)
    }
    
    func bindShowEpisodesList(observable: Observable<Void>) -> Disposable {
        observable
            .bind(to: showEpisodesListRelay)
    }
    
    func bindFavorites() -> Disposable {
        favoritesRepository
            .fetch()
            .map { value in
                !value.filter { $0.id == self.contentIdRelay.value }.isEmpty
            }
            .bind(to: favoriteRelay)
    }
    
    func bindSelectedFavorite(observable: Observable<Void>) -> Disposable {
        observable
            .subscribe(onNext: { _ in
                guard let show = self.contentRelay.value?.show else { return }
                self.favoritesRepository.update(show: show)
            })
    }
}
