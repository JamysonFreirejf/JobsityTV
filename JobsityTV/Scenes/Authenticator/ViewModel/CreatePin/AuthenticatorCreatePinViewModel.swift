//
//  AuthenticatorCreatePinViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

struct AuthenticatorCreatePinViewModel: AuthenticatorViewModelType {
    private let tempPinRelay: BehaviorRelay<String?>
    private let advanceRelay: PublishRelay<Void>
    private let clearInputRelay: PublishRelay<Void>
    private let keychainHelper: KeychainHelper
    
    init(keychainHelper: KeychainHelper = KeychainHelper.shared) {
        self.keychainHelper = keychainHelper
        tempPinRelay = BehaviorRelay(value: nil)
        advanceRelay = PublishRelay()
        clearInputRelay = PublishRelay()
    }
    
    var clearInput: Driver<Void> {
        tempPinRelay
            .filter { $0 != nil }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
    }
    
    var isFingerprintButtonHidden: Driver<Bool> {
        .just(true)
    }
    
    var title: Driver<String?> {
        tempPinRelay
            .map { value in
                value == nil ? "Type PIN Code" : "Confirm PIN Code"
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
        let tempDisp = newPin
            .filter { new in
                self.tempPinRelay.value == nil
            }
            .bind(to: tempPinRelay)
        let advanceDisp = newPin
            .filter { new in
                self.tempPinRelay.value != nil && self.tempPinRelay.value == new
            }
            .flatMapLatest { value in
                self.keychainHelper.rx.savePassword(password: value)
            }
            .take(1)
            .bind(to: advanceRelay)
            
        return Disposables.create([tempDisp, advanceDisp])
    }
}
