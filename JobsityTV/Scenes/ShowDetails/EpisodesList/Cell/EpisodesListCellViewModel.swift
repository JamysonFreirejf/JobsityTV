//
//  EpisodesListCellViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

protocol EpisodesListCellViewModelType {
    var title: Driver<String?> { get }
    var rating: Driver<String?> { get }
    var summary: Driver<String?> { get }
    var airedDate: Driver<String?> { get }
    var airtime: Driver<String?> { get }
    var posterURL: Driver<URL?> { get }
    var widthPoster: Driver<CGFloat> { get }
}

struct EpisodesListCellViewModel: EpisodesListCellViewModelType {
    private let episodeContentRelay: BehaviorRelay<EpisodeContent?>
    
    init(episode: EpisodeContent?) {
        episodeContentRelay = BehaviorRelay(value: episode)
    }
    
    var title: Driver<String?> {
        episodeContentRelay
            .map {
                let number = $0?.number ?? 0
                let title = $0?.name ?? ""
                return "\(number). \(title)"
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var rating: Driver<String?> {
        episodeContentRelay
            .map { $0?.rating?.average ?? 0 }
            .map { String($0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var summary: Driver<String?> {
        episodeContentRelay
            .map { $0?.summary?.removingHTMLTags() }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var airedDate: Driver<String?> {
        episodeContentRelay
            .map { $0?.airdate ?? "" }
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let date = dateFormatter.date(from: $0) {
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    return dateFormatter.string(from: date)
                }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var airtime: Driver<String?> {
        episodeContentRelay
            .map { $0?.airtime ?? "" }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var posterURL: Driver<URL?> {
        episodeContentRelay
            .map { $0?.image?.original ?? "" }
            .map { URL(string: $0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var widthPoster: Driver<CGFloat> {
        posterURL
            .map { $0 == nil ? .zero : 100 }
            .asDriver(onErrorJustReturn: .zero)
    }
}
