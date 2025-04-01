//
//  EventDetailCoordinator.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class EventDetailCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = EventDetailViewModel()
        let vc = EventDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
