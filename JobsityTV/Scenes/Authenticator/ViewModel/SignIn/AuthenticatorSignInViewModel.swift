//
//  AuthenticatorSignInViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

struct AuthenticatorSignInViewModel: AuthenticatorViewModelType {
    private let advanceRelay: PublishRelay<Void>
    private let clearInputRelay: PublishRelay<Void>
    private let keychainHelper: KeychainHelper
    private let errorRelay: BehaviorRelay<String?>
    private let biometricsRepository: BiometricPreferencesRepository
    private let biometricAuthService: BiometricAuthServiceType
    
    init(keychainHelper: KeychainHelper = KeychainHelper.shared,
         biometricsRepository: BiometricPreferencesRepository = BiometricPreferencesUserDefaultsRepository(),
         biometricAuthService: BiometricAuthServiceType = BiometricAuthService()) {
        self.keychainHelper = keychainHelper
        self.biometricsRepository = biometricsRepository
        self.biometricAuthService = biometricAuthService
        advanceRelay = PublishRelay()
        clearInputRelay = PublishRelay()
        errorRelay = BehaviorRelay(value: nil)
    }
    
    var clearInput: Driver<Void> {
        .never()
    }
    
    var isFingerprintButtonHidden: Driver<Bool> {
        .just(!biometricsRepository.fetch())
    }
    
    var title: Driver<String?> {
        errorRelay
            .map {
                $0 == nil ? "Type PIN Code" : $0
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var advance: Driver<Void> {
        advanceRelay.asDriver(onErrorJustReturn: ())
    }
    
    func bindInput(observable: Observable<String?>) -> Disposable {
        let newPin = observable
            .compactMap { $0 }
            .filter { $0.count == 4 }
        let matchPin = newPin
            .flatMapLatest { value in
                self.keychainHelper.rx.retrievePassword().map { ($0, value) }
            }
            .map { current, new in
                current == new
            }
      
        let advanceDisp = matchPin
            .filter { $0 }
            .map { _ in () }
            .take(1)
            .bind(to: advanceRelay)
        let errorDisp = matchPin
            .filter { !$0 }
            .map { _ in "Wrong PIN, Try Again" }
            .bind(to: errorRelay)
            
        return Disposables.create([advanceDisp, errorDisp])
    }
    
    func bindBiometric(observable: Observable<Void>) -> Disposable {
        observable
            .flatMap {
                self.biometricAuthService.authenticate()
            }
            .filter { $0 }
            .map { _ in () }
            .bind(to: advanceRelay)
    }
}
