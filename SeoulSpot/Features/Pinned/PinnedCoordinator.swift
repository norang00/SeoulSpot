//
//  PinnedCoordinator.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class PinnedCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = PinnedViewModel()
        let vc = PinnedViewController(viewModel: viewModel)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetail(for event: CulturalEventModel) {
        let detailVM = EventDetailViewModel(event: event)
        let detailVC = EventDetailViewController(viewModel: detailVM)
        navigationController.topViewController?.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(detailVC, animated: true)
    }
}

extension PinnedCoordinator: PinnedViewControllerDelegate {
    func didSelectEvent(_ event: CulturalEventModel) {
        showDetail(for: event)
    }
}
