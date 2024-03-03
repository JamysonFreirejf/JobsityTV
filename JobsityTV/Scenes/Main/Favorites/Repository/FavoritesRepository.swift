//
//  FavoritesRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift

protocol FavoritesRepository {
    func fetch() -> Observable<[Show]>
    func update(show: Show)
}
