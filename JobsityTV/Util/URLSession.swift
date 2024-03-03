//
//  URLSession.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

protocol URLSessionProtocol {
    func rx_data(request: URLRequest) -> Observable<Data>
}

extension URLSession: URLSessionProtocol {
    func rx_data(request: URLRequest) -> Observable<Data> {
        return rx.data(request: request)
    }
}
