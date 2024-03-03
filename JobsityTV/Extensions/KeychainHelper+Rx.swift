//
//  KeychainHelper+Rx.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

extension KeychainHelper: ReactiveCompatible {}

extension Reactive where Base: KeychainHelper {
    func savePassword(password: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.savePassword(password: password)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func retrievePassword() -> Observable<String?> {
        return Observable.create { observer in
            let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            let subscription = interval.subscribe { _ in
                let value = self.base.retrievePassword()
                observer.onNext(value)
            }
            return Disposables.create {
                subscription.dispose()
            }
        }
        .distinctUntilChanged()
        .startWith(base.retrievePassword())
    }
    
    func deletePassword() -> Observable<Void> {
        return Observable.create { observer in
            self.base.deletePassword()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
