//
//  HomeRemoteRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

struct HomeRemoteRepository: HomeRepository {
    private let apiClient: APIClientType
    private let urlSession: URLSessionProtocol
    
    init(apiClient: APIClientType = APIClient(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.apiClient = apiClient
        self.urlSession = urlSession
    }
    
    func fetch(at page: Int) -> Observable<[Show]> {
        urlSession.rx_data(request: apiClient.buildRequest(.shows(page: page)))
            .map { data in
                let json = try JSONDecoder().decode([Show].self, from: data)
                return json
            }
            .catch { error in
                return .error(error)
            }
    }
}
