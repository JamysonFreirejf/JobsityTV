//
//  SearchCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

final class SearchCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let viewController = SearchOptionsViewController(nibName: String(describing: SearchOptionsViewController.self),
                                                  bundle: nil)
        viewController.viewModel = SearchOptionsViewModel()
        viewController.viewModel?
            .selectedContent
            .drive(onNext: { [weak self] value in
                guard value == .tvShows else {
                    self?.showSearchForPeople()
                    return
                }
                self?.showSearchForTVShows()
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension SearchCoordinator {
    func showSearchForTVShows() {
        let viewModel = SearchTVShowsViewModel()
        viewModel
            .selectedItem
            .drive(onNext: { [weak self] value in
                self?.showDetails(showContentId: value)
            })
            .disposed(by: disposeBag)
        
        showSearch(viewModel: viewModel)
    }
    
    func showSearchForPeople() {
        let viewModel = SearchPeopleViewModel()
        viewModel
            .selectedItem
            .drive(onNext: { [weak self] value in
                self?.showPeopleDetails(peopleContentId: value)
            })
            .disposed(by: disposeBag)
        
        showSearch(viewModel: viewModel)
    }
    
    func showPeopleDetails(peopleContentId: Int?) {
        let coordinator = ShowPeopleDetailsCoordinator()
        coordinator.navigationController = navigationController
        coordinator.peopleContentId = peopleContentId
        start(coordinator: coordinator)
    }
    
    func showDetails(showContentId: Int?) {
        guard let showContentId = showContentId else { return }
        
        let coordinator = ShowDetailsCoordinator()
        coordinator.navigationController = navigationController
        coordinator.showContentId = showContentId
        start(coordinator: coordinator)
    }
    
    func showSearch(viewModel: SearchViewModelType) {
        let viewController = SearchViewController(nibName: String(describing: SearchViewController.self),
                                                  bundle: nil)
        viewController.viewModel = viewModel
        viewController.viewModel?
            .backPressed
            .drive(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
