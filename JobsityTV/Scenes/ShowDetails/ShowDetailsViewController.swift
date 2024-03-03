//
//  ShowDetailsViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

final class ShowDetailsViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var bannersCollectionView: UICollectionView! {
        didSet {
            bannersCollectionView.register(UINib(nibName: String(describing: BannerCollectionViewCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: BannerCollectionViewCell.self))
            bannersCollectionView.delegate = self
        }
    }
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var summaryDescriptionLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var scheduleLabel: UILabel!
    @IBOutlet private weak var averageTimeLabel: UILabel!
    @IBOutlet private weak var episodesButton: UIButton!
    
    var viewModel: ShowDetailsViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBindings()
        setUpRightBarItemBindings()
    }
}

private extension ShowDetailsViewController {
    func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    func setUpBindings() {
        viewModel?.bindContent()
            .disposed(by: disposeBag)
        viewModel?.banners
            .drive(bannersCollectionView.rx.items(cellIdentifier: String(describing: BannerCollectionViewCell.self),
                                           cellType: BannerCollectionViewCell.self)) { _, content, cell in
                cell.setUpView(content: content)
             }
            .disposed(by: disposeBag)
        viewModel?.posterURL
            .drive(onNext: { [weak self] value in
                self?.posterImageView.pin_setImage(from: value)
            })
            .disposed(by: disposeBag)
        viewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.summary
            .drive(summaryDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.subTitle
            .drive(subTitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.genre
            .drive(genreLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.stars
            .drive(starsLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.scheduleTime
            .drive(scheduleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.averageTime
            .drive(averageTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.episodesCount
            .drive(episodesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        viewModel?.bindShowEpisodesList(observable: episodesButton.rx.tap.asObservable())
            .disposed(by: disposeBag)
    }
    
    func setUpRightBarItemBindings() {
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        viewModel?.favoriteImage
            .drive(rightBarButtonItem.rx.image)
            .disposed(by: disposeBag)
        viewModel?.bindSelectedFavorite(observable: rightBarButtonItem.rx.tap.asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindFavorites()
            .disposed(by: disposeBag)
    }
}

extension ShowDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
