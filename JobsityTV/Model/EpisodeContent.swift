//
//  EpisodeContent.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import Foundation

struct EpisodeContent: Codable {
    let id: Int
    let season: Int?
    let number: Int?
    let name: String?
    let airdate: String?
    let airtime: String?
    let rating: RatingContent?
    let image: ImageEpisodeContent?
    let summary: String?
    let runtime: Int?
}

struct ImageEpisodeContent: Codable {
    let original: String?
}
