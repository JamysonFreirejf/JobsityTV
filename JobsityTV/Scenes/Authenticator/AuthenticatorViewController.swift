//
//  AuthenticatorViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthenticatorViewController: UIViewController {
    @IBOutlet private weak var inputTextField: UITextField! {
        didSet {
            inputTextField.isSecureTextEntry = true
            inputTextField.delegate = self
        }
    }
    @IBOutlet private weak var touchButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var viewModel: AuthenticatorViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
    }
}

private extension AuthenticatorViewController {
    func setUpBindings() {
        viewModel?.isFingerprintButtonHidden
            .drive(touchButton.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.bindInput(observable: inputTextField.rx.text.asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindBiometric(observable: touchButton.rx.tap.asObservable())
            .disposed(by: disposeBag)
        viewModel?.clearInput
            .drive(onNext: { [weak self] _ in
                self?.inputTextField.text = nil
            })
            .disposed(by: disposeBag)
    }
}

extension AuthenticatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 4
    }
}
