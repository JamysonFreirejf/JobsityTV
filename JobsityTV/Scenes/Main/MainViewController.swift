//
//  MainViewController.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UITabBarController {

    var viewModel: MainViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBindings()
    }
}

private extension MainViewController {
    func setUpView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    func setUpBindings() {
        guard let searchObservable = navigationItem.rightBarButtonItem?.rx.tap.asObservable() else { return }
        viewModel?.bindSearch(observable: searchObservable)
            .disposed(by: disposeBag)
        
        guard let settingsObservable = navigationItem.leftBarButtonItem?.rx.tap.asObservable() else { return }
        viewModel?.bindSettings(observable: settingsObservable)
            .disposed(by: disposeBag)
    }
}
