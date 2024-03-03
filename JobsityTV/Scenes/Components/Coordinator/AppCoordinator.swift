//
//  AppCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow?
    private let keychainHelper: KeychainHelper
    
    init(keychainHelper: KeychainHelper = KeychainHelper.shared, window: UIWindow?) {
        self.keychainHelper = keychainHelper
        self.window = window
    }
    
    override func start() {
        navigationController.navigationBar.tintColor = .label
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        guard keychainHelper.retrievePassword() == nil else {
            showAuthFlow()
            return
        }
        showMainFlow()
    }
}

private extension AppCoordinator {
    func showMainFlow() {
        let coordinator = MainCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    func showAuthFlow() {
        let coordinator = AuthenticatorCoordinator()
        coordinator.navigationController = navigationController
        coordinator.option = .signIn
        start(coordinator: coordinator)
    }
}
