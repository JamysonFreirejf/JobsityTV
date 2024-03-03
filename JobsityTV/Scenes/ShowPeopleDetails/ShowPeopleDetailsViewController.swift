//
//  ShowPeopleDetailsViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

final class ShowPeopleDetailsViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: String(describing: ShowCollectionViewCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: ShowCollectionViewCell.self))
            collectionView.delegate = self
        }
    }
    
    var viewModel: ShowPeopleDetailsViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

private extension ShowPeopleDetailsViewController {
    func setUpBindings() {
        viewModel?.bindFetch()
            .disposed(by: disposeBag)
        viewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.posterURL
            .drive(onNext: { [weak self] value in
                self?.posterImageView.pin_setImage(from: value)
            })
            .disposed(by: disposeBag)
        viewModel?.castCreditsContent
            .drive(collectionView.rx.items(cellIdentifier: String(describing: ShowCollectionViewCell.self),
                                           cellType: ShowCollectionViewCell.self)) { _, content, cell in
                cell.setUpView(content: content)
             }
            .disposed(by: disposeBag)
        viewModel?.bindSelectedItem(observable: collectionView.rx.modelSelected(ShowSearchData.self).asObservable())
            .disposed(by: disposeBag)
    }
}

extension ShowPeopleDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: collectionView.frame.height)
    }
}
