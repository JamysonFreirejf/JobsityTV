//
//  HomeViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: String(describing: ShowCollectionViewCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: ShowCollectionViewCell.self))
            collectionView.delegate = self
        }
    }
    
    var viewModel: HomeViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

private extension HomeViewController {
    func setUpBindings() {
        viewModel?.bindFetch()
            .disposed(by: disposeBag)
        viewModel?.bindPrefetch(observable: collectionView.rx.prefetchItems.asObservable())
            .disposed(by: disposeBag)
        viewModel?.content
            .drive(collectionView.rx.items(cellIdentifier: String(describing: ShowCollectionViewCell.self), 
                                           cellType: ShowCollectionViewCell.self)) { _, show, cell in
                cell.setUpView(content: show)
             }
            .disposed(by: disposeBag)
        viewModel?.bindSelectedItem(observable: collectionView.rx.modelSelected(ShowSearchData.self).asObservable())
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2, height: 300)
    }
}
