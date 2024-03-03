//
//  PickerViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PickerViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    var viewModel: PickerViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        setUpListeners()
    }
}

private extension PickerViewController {
    func setUpBindings() {
        viewModel?.content
            .drive(pickerView.rx.itemTitles) { _, item in
                item.title
            }
            .disposed(by: disposeBag)
        viewModel?.bindSelected(observable: pickerView.rx.modelSelected(PickerItem.self).asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindConfirm(observable: confirmButton.rx.tap.asObservable())
            .disposed(by: disposeBag)
    }
    
    func setUpListeners() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        viewModel?.confirm
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
