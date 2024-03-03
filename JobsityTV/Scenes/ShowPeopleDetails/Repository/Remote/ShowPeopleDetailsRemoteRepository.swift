//
//  ShowPeopleDetailsRemoteRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift

struct ShowPeopleDetailsRemoteRepository: ShowPeopleDetailsRepository {
    private let apiClient: APIClientType
    private let urlSession: URLSessionProtocol
    
    init(apiClient: APIClientType = APIClient(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.apiClient = apiClient
        self.urlSession = urlSession
    }
    
    func fetch(id: Int) -> Observable<PeopleDetailsContent> {
        let credits: Observable<[CastCreditsContent]> = fetch(.showPeopleDetailsCredits(id: id))
        let details: Observable<PeopleContent> = fetch(.showPeopleDetails(id: id))
        return Observable.zip(credits, details)
            .map {
                PeopleDetailsContent(castCredits: $0.0, peopleContent: $0.1)
            }
    }
}

private extension ShowPeopleDetailsRemoteRepository {
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
