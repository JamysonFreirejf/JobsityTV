//
//  ShowDetailsRemoteRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

struct ShowDetailsRemoteRepository: ShowDetailsRepository {
    private let apiClient: APIClientType
    private let urlSession: URLSessionProtocol
    
    init(apiClient: APIClientType = APIClient(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.apiClient = apiClient
        self.urlSession = urlSession
    }
    
    func fetch(id: Int) -> Observable<ShowDetailsContent> {
        let showDetails: Observable<Show> = fetch(.showDetails(id: id))
        let fullImages: Observable<[ImageFullContent]> = fetch(.showFullImages(id: id))
        let episodes: Observable<[EpisodeContent]> = fetch(.episodesList(id: id))
        return Observable.zip(showDetails, fullImages, episodes)
            .map { ShowDetailsContent(show: $0.0, images: $0.1, episodes: $0.2) }
    }
    
    func fetch(query: String) -> Observable<[SearchShow]>{
        urlSession.rx_data(request: apiClient.buildRequest(.searchShows(query: query)))
            .map { data in
                let json = try JSONDecoder().decode([SearchShow].self, from: data)
                return json
            }
            .catch { error in
                return .error(error)
            }
    }
}

private extension ShowDetailsRemoteRepository {
    func fetch<T: Codable>(_ router: APIRouter) -> Observable<T> {
        urlSession.rx_data(request: apiClient.buildRequest(router))
            .map { data in
                let json = try JSONDecoder().decode(T.self, from: data)
                return json
            }
            .catch { error in
                return .error(error)
            }
    }
}
