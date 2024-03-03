//
//  BiometricAuthService.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import LocalAuthentication
import RxSwift

enum BiometricAuthServiceError: Error {
    case noBiometry
}

protocol BiometricAuthServiceType {
    var isAvailable: Bool { get }
    
    func authenticate() -> Observable<Bool>
}

struct BiometricAuthService: BiometricAuthServiceType {
    var isAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticate() -> Observable<Bool> {
        return Observable.create { observer in
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    observer.onNext(success)
                    observer.onCompleted()
                }
            } else {
                observer.onError(BiometricAuthServiceError.noBiometry)
            }
            return Disposables.create()
        }
    }
}
