//
//  SettingsCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

final class SettingsCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let viewController = SettingsViewController(nibName: String(describing: SettingsViewController.self),
                                                  bundle: nil)
        viewController.viewModel = SettingsViewModel()
        viewController.viewModel?
            .showAuthFlow
            .drive(onNext: { [weak self] _ in
                self?.showPinAuthFlow()
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension SettingsCoordinator {
    func showPinAuthFlow() {
        let coordinator = AuthenticatorCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
