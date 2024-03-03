//
//  Show.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RealmSwift

final class Show: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var genres: List<String>
    @Persisted var image: ShowImage?
    @Persisted var summary: String?
    @Persisted var premiered: String?
    @Persisted var ended: String?
    @Persisted var status: String
    @Persisted var rating: RatingContent?
    @Persisted var schedule: ScheduleContent?
    @Persisted var averageRuntime: Int?
}

final class ShowImage: Object, Codable {
    @Persisted var original: String?
    @Persisted var medium: String?
}

final class RatingContent: Object, Codable {
    @Persisted var average: Double?
}

final class ScheduleContent: Object, Codable {
    @Persisted var time: String?
    @Persisted var days: List<String>
}
