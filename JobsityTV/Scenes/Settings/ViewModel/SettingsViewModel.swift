//
//  SettingsViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol SettingsViewModelType {
    var isPinEnabled: Driver<Bool> { get }
    var showAuthFlow: Driver<Void> { get }
    var isBiometricHidden: Driver<Bool> { get }
    var isBiometricOn: Driver<Bool> { get }
    
    func bindPinSwitch(observable: Observable<Void>) -> Disposable
    func bindBiometric(observable: Observable<Bool>) -> Disposable
}

struct SettingsViewModel: SettingsViewModelType {
    private let keychainHelper: KeychainHelper
    private let biometricAuthService: BiometricAuthServiceType
    private let pinPressRelay: PublishRelay<Void>
    private let biometricRepository: BiometricPreferencesRepository
    
    init(keychainHelper: KeychainHelper = KeychainHelper.shared,
         biometricAuthService: BiometricAuthServiceType = BiometricAuthService(),
         biometricRepository: BiometricPreferencesRepository = BiometricPreferencesUserDefaultsRepository()) {
        self.keychainHelper = keychainHelper
        self.biometricAuthService = biometricAuthService
        self.biometricRepository = biometricRepository
        pinPressRelay = PublishRelay()
    }
    
    var isPinEnabled: Driver<Bool> {
        keychainHelper.rx.retrievePassword()
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
    }
    
    var showAuthFlow: Driver<Void> {
        pinPressRelay
            .withLatestFrom(keychainHelper.rx.retrievePassword())
            .filter { $0 == nil }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
    }
    
    var isBiometricHidden: Driver<Bool> {
        Observable.combineLatest(Observable.just(biometricAuthService.isAvailable), keychainHelper.rx.retrievePassword())
            .map { isAvailable, passwd in
                if passwd == nil {
                    return true
                }
                return !isAvailable
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    var isBiometricOn: Driver<Bool> {
        .just(biometricRepository.fetch())
    }
    
    func bindPinSwitch(observable: Observable<Void>) -> Disposable {
        let pinDisp = observable
            .bind(to: pinPressRelay)
        let deleteDisp = observable
            .withLatestFrom(keychainHelper.rx.retrievePassword())
            .filter { $0 != nil }
            .subscribe(onNext: { _ in
                self.biometricRepository.clear()
                self.keychainHelper.deletePassword()
            })
        
        return Disposables.create([pinDisp, deleteDisp])
    }
    
    func bindBiometric(observable: Observable<Bool>) -> Disposable {
        observable
            .skip(1)
            .subscribe(onNext: { value in
                self.biometricRepository.update(enabled: value)
            })
    }
}
