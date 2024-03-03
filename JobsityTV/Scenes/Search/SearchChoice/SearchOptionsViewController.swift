//
//  SearchOptionsViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchOptionsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: SearchChoiceTableViewCell.self), bundle: nil),
                                    forCellReuseIdentifier: String(describing: SearchChoiceTableViewCell.self))
            tableView.delegate = self
        }
    }
    
    var viewModel: SearchOptionsViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

private extension SearchOptionsViewController {
    func setUpBindings() {
        viewModel?.options
            .drive(tableView.rx.items(cellIdentifier: String(describing: SearchChoiceTableViewCell.self),
                                      cellType: SearchChoiceTableViewCell.self)) { _, content, cell in
                cell.setUpView(title: content.title)
            }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.tableView.deselectRow(at: index, animated: true)
            })
            .disposed(by: disposeBag)
        viewModel?.bindSelectedContent(observable: tableView.rx.modelSelected(SearchOption.self).asObservable())
            .disposed(by: disposeBag)
    }
}

extension SearchOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
