//
//  SearchPeopleRemoteRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift

struct SearchPeopleRemoteRepository: SearchShowRepository {
    private let apiClient: APIClientType
    private let urlSession: URLSessionProtocol
    
    init(apiClient: APIClientType = APIClient(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.apiClient = apiClient
        self.urlSession = urlSession
    }
    
    func fetch<T: Codable>(query: String) -> Observable<T>{
        let observable: Observable<T> = urlSession.rx_data(request: apiClient.buildRequest(.searchPeople(query: query)))
            .map { data in
                let json = try JSONDecoder().decode(T.self, from: data)
                return json
            }
            .catch { error in
                return .error(error)
            }
        return observable
    }
}
