//
//  APIRouter.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum APIRouter {
    case shows(page: Int)
    case searchShows(query: String)
    case showDetails(id: Int)
    case showFullImages(id: Int)
    case episodesList(id: Int)
    case searchPeople(query: String)
    case showPeopleDetails(id: Int)
    case showPeopleDetailsCredits(id: Int)
    
    var path: String {
        switch self {
        case .shows(page: _):
            return "shows"
        case .searchShows(query: _):
            return "search/shows"
        case .showDetails(id: let id):
            return "shows/\(id)"
        case .showFullImages(id: let id):
            return "shows/\(id)/images"
        case .episodesList(id: let id):
            return "shows/\(id)/episodes"
        case .searchPeople(query: _):
            return "search/people"
        case .showPeopleDetails(id: let id):
            return "people/\(id)"
        case .showPeopleDetailsCredits(id: let id):
            return "people/\(id)/castcredits"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryParams: [URLQueryItem] {
        switch self {
        case .shows(page: let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .searchShows(query: let query):
            return [URLQueryItem(name: "q", value: query)]
        case .searchPeople(query: let query):
            return [URLQueryItem(name: "q", value: query)]
        case .showPeopleDetailsCredits(id: _):
            return [URLQueryItem(name: "embed", value: "show")]
        default:
            return []
        }
    }
}
