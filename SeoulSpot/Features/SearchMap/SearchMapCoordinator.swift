//
//  SearchMapCoordinator.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class SearchMapCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = SearchMapViewModel()
        let vc = SearchMapViewController(viewModel: viewModel)
//        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
}

//extension SearchMapCoordinator: SearchMapViewControllerDelegate {
//    func didSelectEvent(_ event: Event) {
//        let detailVC = EventDetailViewController(event: event)
//        navigationController.pushViewController(detailVC, animated: true)
//    }
//}
