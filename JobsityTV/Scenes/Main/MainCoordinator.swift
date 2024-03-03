//
//  MainCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

final class MainCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        guard
            let mainViewController = UIStoryboard.main.instantiateInitialViewController() as? MainViewController,
            let homeViewController = mainViewController.viewControllers?.first as? HomeViewController,
            let favoritesViewController = mainViewController.viewControllers?.last as? FavoritesViewController else {
            return
        }
        mainViewController.viewModel = MainViewModel()
        mainViewController.viewModel?
            .searchPressed
            .drive(onNext: { [weak self] _ in
                self?.showSearchScreen()
            })
            .disposed(by: disposeBag)
        mainViewController.viewModel?
            .showSettingsPressed
            .drive(onNext: { [weak self] _ in
                self?.showSettings()
            })
            .disposed(by: disposeBag)
        
        homeViewController.viewModel = HomeViewModel()
        homeViewController.viewModel?
            .selectedItem
            .drive(onNext: { [weak self] showContent in
                self?.showDetailsScreen(showContent: showContent)
            })
            .disposed(by: disposeBag)
        
        favoritesViewController.viewModel = FavoritesViewModel()
        favoritesViewController.viewModel?
            .selectedItem
            .drive(onNext: { [weak self] showContent in
                self?.showDetailsScreen(showContent: showContent)
            })
            .disposed(by: disposeBag)
        
        navigationController.viewControllers = [mainViewController]
    }
}

private extension MainCoordinator {
    func showSearchScreen() {
        let coordinator = SearchCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    func showSettings() {
        let coordinator = SettingsCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    func showDetailsScreen(showContent: Show?) {
        guard let showContent = showContent else { return }
        
        let coordinator = ShowDetailsCoordinator()
        coordinator.navigationController = navigationController
        coordinator.showContentId = showContent.id
        start(coordinator: coordinator)
    }
}
