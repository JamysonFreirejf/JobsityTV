//
//  FavoritesViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: String(describing: ShowCollectionViewCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: ShowCollectionViewCell.self))
            collectionView.delegate = self
        }
    }
    @IBOutlet private weak var alphabeticalSwitch: UISwitch!
    
    var viewModel: FavoritesViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

private extension FavoritesViewController {
    func setUpBindings() {
        viewModel?.bindFetch()
            .disposed(by: disposeBag)
        viewModel?.content
            .drive(collectionView.rx.items(cellIdentifier: String(describing: ShowCollectionViewCell.self),
                                           cellType: ShowCollectionViewCell.self)) { _, show, cell in
                cell.setUpView(content: show)
             }
            .disposed(by: disposeBag)
        viewModel?.isAlphabeticalActive
            .drive(alphabeticalSwitch.rx.isOn)
            .disposed(by: disposeBag)
        viewModel?.bindAlphabeticalSlider(observable: alphabeticalSwitch.rx.isOn.asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindSelectedItem(observable: collectionView.rx.modelSelected(ShowSearchData.self).asObservable())
            .disposed(by: disposeBag)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2, height: 300)
    }
}
