//
//  RealmHandler.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RealmSwift

final class RealmHandler {
    let realm = try! Realm()
    
    static var shared: RealmHandler = RealmHandler()
}
