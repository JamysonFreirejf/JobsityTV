//
//  AuthenticatorViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

protocol AuthenticatorViewModelType {
    var isFingerprintButtonHidden: Driver<Bool> { get }
    var title: Driver<String?> { get }
    var clearInput: Driver<Void> { get }
    var advance: Driver<Void> { get }
    
    func bindInput(observable: Observable<String?>) -> Disposable 
    func bindBiometric(observable: Observable<Void>) -> Disposable
}

extension AuthenticatorViewModelType {
    func bindBiometric(observable: Observable<Void>) -> Disposable {
        Disposables.create()
    }
}
