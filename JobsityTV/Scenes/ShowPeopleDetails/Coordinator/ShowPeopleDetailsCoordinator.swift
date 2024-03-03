//
//  ShowPeopleDetailsCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import RxSwift
import RxCocoa

final class ShowPeopleDetailsCoordinator: BaseCoordinator {
    
    var peopleContentId: Int?
    private let disposeBag = DisposeBag()
    
    override func start() {
        let viewController = ShowPeopleDetailsViewController(nibName: String(describing: ShowPeopleDetailsViewController.self),
                                                  bundle: nil)
        viewController.viewModel = ShowPeopleDetailsViewModel(peopleContentId: peopleContentId)
        viewController.viewModel?
            .selectItem
            .drive(onNext: { [weak self] value in
                self?.showDetailsTVShow(contentId: value)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ShowPeopleDetailsCoordinator {
    func showDetailsTVShow(contentId: Int?) {
        guard let contentId = contentId else { return }
        let coordinator = ShowDetailsCoordinator()
        coordinator.navigationController = navigationController
        coordinator.showContentId = contentId
        start(coordinator: coordinator)
    }
}
