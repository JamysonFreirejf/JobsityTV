//
//  SearchShowRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

protocol SearchShowRepository {
    func fetch<T: Codable>(query: String) -> Observable<T>
}
