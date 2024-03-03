//
//  SearchPeople.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Foundation

struct SearchPeople: Codable {
    let person: PeopleContent?
}

struct PeopleContent: Codable {
    let id: Int?
    let name: String?
    let image: PeopleImage?
}

struct PeopleImage: Codable {
    let original: String?
}
