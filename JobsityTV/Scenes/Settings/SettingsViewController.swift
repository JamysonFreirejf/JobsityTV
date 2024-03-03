//
//  SettingsViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {
    @IBOutlet private weak var enablePinSwitch: UISwitch!
    @IBOutlet private weak var enableTouchFaceLabel: UILabel!
    @IBOutlet private weak var enableTouchFaceSwitch: UISwitch!
    @IBOutlet private weak var pinView: UIView!
    
    private lazy var pinGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer()
    }()
    
    var viewModel: SettingsViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinView.addGestureRecognizer(pinGesture)
        setUpBindings()
    }
}

private extension SettingsViewController {
    func setUpBindings() {
        viewModel?.isBiometricOn
            .drive(enableTouchFaceSwitch.rx.isOn)
            .disposed(by: disposeBag)
        viewModel?.isPinEnabled
            .drive(enablePinSwitch.rx.isOn)
            .disposed(by: disposeBag)
        viewModel?.bindPinSwitch(observable: pinGesture.rx.event.map { _ in () })
            .disposed(by: disposeBag)
        viewModel?.bindBiometric(observable: enableTouchFaceSwitch.rx.isOn.asObservable())
            .disposed(by: disposeBag)
        viewModel?.isBiometricHidden
            .drive(enableTouchFaceSwitch.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel?.isBiometricHidden
            .drive(enableTouchFaceLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel?.isBiometricOn
            .drive(enableTouchFaceSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
