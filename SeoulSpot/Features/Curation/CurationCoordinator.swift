//
//  CurationCoordinator.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class CurationCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let curationVM = CurationViewModel()
        let curationVC = CurationViewController(viewModel: curationVM)
        curationVC.delegate = self
        navigationController.pushViewController(curationVC, animated: false)
    }
    
    func showDetail(for event: CulturalEventModel) {
        let detailVM = EventDetailViewModel(event: event)
        let detailVC = EventDetailViewController(viewModel: detailVM)
        navigationController.topViewController?.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(detailVC, animated: true)
    }
}

extension CurationCoordinator: CurationViewControllerDelegate {
    func didSelectEvent(_ event: CulturalEventModel) {
        showDetail(for: event)
    }
}
