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

        print("CurationCoordinator", #function)
    }

    func start() {
        let viewModel = CurationViewModel()
        let curationVC = CurationViewController(viewModel: viewModel)
        curationVC.delegate = self
        navigationController.pushViewController(curationVC, animated: false)

        print("CurationCoordinator", #function, curationVC.delegate)
    }
    
    func showDetail(for event: CulturalEvent) {
        print(#function)
        let viewModel = EventDetailViewModel(event: event)
        let detailVC = EventDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

extension CurationCoordinator: CurationViewControllerDelegate {
    func didSelectEvent(_ event: CulturalEvent) {
        print(#function, event.title)
        showDetail(for: event)
    }
}
