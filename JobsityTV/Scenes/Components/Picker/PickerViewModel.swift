//
//  PickerViewModel.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

struct PickerItem {
    let key: String
    let title: String
}

protocol PickerViewModelType {
    var content: Driver<[PickerItem]> { get }
    var selected: Driver<PickerItem?> { get }
    var confirm: Driver<Void> { get }
    
    func bindConfirm(observable: Observable<Void>) -> Disposable 
    func bindSelected(observable: Observable<[PickerItem]>) -> Disposable
}

struct PickerViewModel: PickerViewModelType {
    private let contentRelay: BehaviorRelay<[PickerItem]>
    private let confirmRelay: PublishRelay<Void>
    private let selectedRelay: PublishRelay<PickerItem?>
    
    init(items: [PickerItem]) {
        contentRelay = BehaviorRelay(value: items)
        confirmRelay = PublishRelay()
        selectedRelay = PublishRelay()
    }
    
    var content: Driver<[PickerItem]> {
        contentRelay.asDriver()
    }
    
    var selected: Driver<PickerItem?> {
       confirmRelay
            .withLatestFrom(selectedRelay.startWith(contentRelay.value.first))
            .distinctUntilChanged { old, new in
                old?.key == new?.key
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var confirm: Driver<Void> {
        confirmRelay.asDriver(onErrorJustReturn: ())
    }
    
    func bindConfirm(observable: Observable<Void>) -> Disposable {
        observable.bind(to: confirmRelay)
    }
    
    func bindSelected(observable: Observable<[PickerItem]>) -> Disposable {
        observable
            .map { $0.last }
            .compactMap { $0 }
            .bind(to: selectedRelay)
    }
}
