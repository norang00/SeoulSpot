//
//  SearchMapViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

//protocol SearchMapViewControllerDelegate: AnyObject {
//    func didSelectEvent(_ event: Event)
//}

final class SearchMapViewController: BaseViewController<SearchMapView, SearchMapViewModel> {

//    weak var delegate: SearchMapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomSheetVC = SearchMapBottomSheetViewController()

        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        bottomSheetVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSheetVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSheetVC.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        

    }

    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showLoading($0) }
            .store(in: &cancellables)

        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showError($0) }
            .store(in: &cancellables)
    }
}
