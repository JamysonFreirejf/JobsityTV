//
//  ShowPeopleDetailsRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift

protocol ShowPeopleDetailsRepository {
    func fetch(id: Int) -> Observable<PeopleDetailsContent>
}
