//
//  ShowDetailsRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift

protocol ShowDetailsRepository {
    func fetch(id: Int) -> Observable<ShowDetailsContent>
}
