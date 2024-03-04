//
//  ShowDetailsCoordinator.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import RxSwift
import RxCocoa

final class ShowDetailsCoordinator: BaseCoordinator {
    
    var showContentId: Int?
    private let disposeBag = DisposeBag()
    private weak var episodesListViewController: EpisodesListViewController?

    override func start() {
        guard let contentId = showContentId else { return }
        let viewController = ShowDetailsViewController(nibName: String(describing: ShowDetailsViewController.self),
                                                  bundle: nil)
        viewController.viewModel = ShowDetailsViewModel(contentId: contentId)
        viewController.viewModel?
            .episodesListPressed
            .drive(onNext: { [weak self] episodes in
                self?.showEpisodesList(episodes: episodes)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ShowDetailsCoordinator {
    func showEpisodesList(episodes: [EpisodeContent]) {
        guard !episodes.isEmpty else { return }
        let viewController = EpisodesListViewController(nibName: String(describing: EpisodesListViewController.self),
                                                  bundle: nil)
        episodesListViewController = viewController
        viewController.viewModel = EpisodesListViewModel(episodes: episodes)
        viewController.viewModel?
            .showSeasons
            .drive(onNext: { [weak self] value in
                self?.showPicker(items: value)
            })
            .disposed(by: disposeBag)
        viewController.viewModel?
            .selectedItem
            .drive(onNext: { [weak self] value in
                self?.showEpisodeDetail(episode: value)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPicker(items: [PickerItem]) {
        let viewController = PickerViewController(nibName: String(describing: PickerViewController.self),
                                                  bundle: nil)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.viewModel = PickerViewModel(items: items)
        
        guard let viewModel = viewController.viewModel else { return }
        episodesListViewController?.viewModel?
            .bindSeasonSelected(observable: viewModel.selected.asObservable())
            .disposed(by: disposeBag)
        
        navigationController.present(viewController, animated: true)
    }
    
    func showEpisodeDetail(episode: EpisodeContent?) {
        guard let episode = episode else { return }
        let viewController = ShowEpisodeViewController(nibName: String(describing: ShowEpisodeViewController.self),
                                                  bundle: nil)
        viewController.viewModel = ShowEpisodeViewModel(episode: episode)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
