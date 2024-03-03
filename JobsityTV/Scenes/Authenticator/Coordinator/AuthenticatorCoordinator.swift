//
//  AuthenticatorCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

enum AuthenticatorOption {
    case createPin
    case signIn
}

final class AuthenticatorCoordinator: BaseCoordinator {
    
    var option: AuthenticatorOption = .createPin
    private let disposeBag = DisposeBag()
    
    private var authenticatorViewModel: AuthenticatorViewModelType {
        get {
            switch option {
            case .signIn:
                return AuthenticatorSignInViewModel()
            default:
                return AuthenticatorCreatePinViewModel()
            }
        }
    }
    
    override func start() {
        let viewController = AuthenticatorViewController(nibName: String(describing: AuthenticatorViewController.self),
                                                  bundle: nil)
        viewController.viewModel = authenticatorViewModel
        viewController.viewModel?
            .advance
            .drive(onNext: { [weak self] _ in
                guard self?.option == .createPin else {
                    self?.showMainFlow()
                    return
                }
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension AuthenticatorCoordinator {
    func showMainFlow() {
        let coordinator = MainCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
