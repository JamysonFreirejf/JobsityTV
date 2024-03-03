//
//  SearchOption.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Foundation

enum SearchOption {
    case tvShows
    case people
    
    var title: String {
        switch self {
        case .tvShows:
            return "Search for TV shows"
        case .people:
            return "Search for people"
        }
    }
}
