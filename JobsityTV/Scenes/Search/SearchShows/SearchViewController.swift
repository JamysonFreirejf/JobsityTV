//
//  SearchViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: String(describing: ShowCollectionViewCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: ShowCollectionViewCell.self))
            collectionView.delegate = self
        }
    }
    
    var viewModel: SearchViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

private extension SearchViewController {
    func setUpBindings() {
        viewModel?.bindBack(observable: backButton.rx.tap.asObservable())
            .disposed(by: disposeBag)
        viewModel?.bindInput(observable: inputTextField.rx.text.orEmpty.asObservable())
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

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2, height: 300)
    }
}
