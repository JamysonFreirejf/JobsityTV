//
//  FavoritesLocalRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RealmSwift

struct FavoritesLocalRepository: FavoritesRepository {
    private let realm: Realm
    
    init(realm: Realm = RealmHandler.shared.realm) {
        self.realm = realm
    }
    
    func fetch() -> Observable<[Show]> {
        Observable.collection(from: realm.objects(Show.self))
            .map { Array($0) }
    }
    
    func update(show: Show) {
        let current = realm.objects(Show.self)
        let currentItem = current.filter { $0.id == show.id }
        let exists = !currentItem.isEmpty
        
        try? realm.write {
            if exists {
                self.realm.delete(currentItem)
                return
            }
            self.realm.add(show, update: .all)
        }
    }
}
