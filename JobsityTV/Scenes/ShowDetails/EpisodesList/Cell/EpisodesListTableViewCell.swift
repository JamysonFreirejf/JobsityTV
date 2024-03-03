//
//  EpisodesListTableViewCell.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import PINRemoteImage
import RxSwift
import RxCocoa

final class EpisodesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var posterWidthConstraint: NSLayoutConstraint!
    
    private var viewModel: EpisodesListCellViewModelType?
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        posterImageView.image = nil
    }
    
    func setUpView(episode: EpisodeContent?) {
        viewModel = EpisodesListCellViewModel(episode: episode)
        viewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.rating
            .drive(ratingLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.airedDate
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.airtime
            .drive(durationLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.summary
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.posterURL
            .drive(onNext: { [weak self] value in
                self?.posterImageView.pin_setImage(from: value)
            })
            .disposed(by: disposeBag)
        viewModel?.widthPoster
            .drive(posterWidthConstraint.rx.constant)
            .disposed(by: disposeBag)
    }
}
