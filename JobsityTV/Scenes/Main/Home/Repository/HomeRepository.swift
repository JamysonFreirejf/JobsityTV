//
//  HomeRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

protocol HomeRepository {
    func fetch(at page: Int) -> Observable<[Show]>
}
