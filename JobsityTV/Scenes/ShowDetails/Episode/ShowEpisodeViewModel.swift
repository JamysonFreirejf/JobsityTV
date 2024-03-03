//
//  ShowEpisodeViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol ShowEpisodeViewModelType {
    var title: Driver<String?> { get }
    var subTitle: Driver<String?> { get }
    var posterURL: Driver<URL?> { get }
    var rating: Driver<String?> { get }
    var summary: Driver<String?> { get }
    var airedDate: Driver<String?> { get }
    var airtime: Driver<String?> { get }
    var posterHeight: Driver<CGFloat> { get }
}

struct ShowEpisodeViewModel: ShowEpisodeViewModelType {
    private let contentRelay: BehaviorRelay<EpisodeContent>
    
    init(episode: EpisodeContent) {
        contentRelay = BehaviorRelay(value: episode)
    }
    
    var title: Driver<String?> {
        contentRelay
            .map { $0.name }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var subTitle: Driver<String?> {
        contentRelay
            .map { value in
                let number = value.number ?? 0
                let season = value.season ?? 0
                let duration = value.runtime ?? 0
                return "Season \(season) | Episode \(number) | \(duration) min"
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var posterURL: Driver<URL?> {
        contentRelay
            .map { $0.image?.original ?? "" }
            .map { URL(string: $0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var rating: Driver<String?> {
        contentRelay
            .map { $0.rating?.average ?? 0 }
            .map { String($0) }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var summary: Driver<String?> {
        contentRelay
            .map { $0.summary?.removingHTMLTags() }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var airedDate: Driver<String?> {
        contentRelay
            .map { $0.airdate ?? "" }
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
        contentRelay
            .map { $0.airtime }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var posterHeight: Driver<CGFloat> {
        posterURL
            .map { $0 == nil ? .zero : 200 }
            .asDriver(onErrorJustReturn: .zero)
    }
}
