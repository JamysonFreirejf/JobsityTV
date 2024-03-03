//
//  EpisodesListViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EpisodesListViewController: UIViewController {
    @IBOutlet private weak var seasonsButton: UIButton!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: EpisodesListTableViewCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: EpisodesListTableViewCell.self))
            tableView.delegate = self
        }
    }
    
    var viewModel: EpisodesListViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

private extension EpisodesListViewController {
    func setUpBindings() {
        viewModel?.seasonSelectedTitle
            .drive(seasonsButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        viewModel?.content
            .drive(tableView.rx.items(cellIdentifier: String(describing: EpisodesListTableViewCell.self),
                                           cellType: EpisodesListTableViewCell.self)) { _, content, cell in
                cell.setUpView(episode: content)
             }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        viewModel?.bindSeasonPress(observable: seasonsButton.rx.tap.asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindSelectedItem(observable: tableView.rx.modelSelected(EpisodeContent.self).asObservable())
            .disposed(by: disposeBag)
    }
}

extension EpisodesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
