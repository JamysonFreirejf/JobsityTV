//
//  ShowEpisodeViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

final class ShowEpisodeViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var airtimeLabel: UILabel!
    @IBOutlet private weak var airdateLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var posterHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ShowEpisodeViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
}

private extension ShowEpisodeViewController {
    func setUpBindings() {
        viewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.subTitle
            .drive(subTitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.rating
            .drive(ratingLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.airtime
            .drive(airtimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.airedDate
            .drive(airdateLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.summary
            .drive(summaryLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel?.posterHeight
            .drive(posterHeightConstraint.rx.constant)
            .disposed(by: disposeBag)
        viewModel?.posterURL
            .drive(onNext: { [weak self] value in
                self?.posterImageView.pin_setImage(from: value)
            })
            .disposed(by: disposeBag)
    }
}
