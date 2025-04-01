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
        let viewModel = CurationViewModel()
        let vc = CurationViewController(viewModel: viewModel)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetail(for event: CulturalEvent) {
        let viewModel = EventDetailViewModel()
        let detailVC = EventDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

extension CurationCoordinator: CurationViewControllerDelegate {
    func didSelectEvent(_ event: CulturalEvent) {
        showDetail(for: event)
    }
}
