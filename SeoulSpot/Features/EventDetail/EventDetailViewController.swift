//
//  EventDetailViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

protocol EventDetailViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

final class EventDetailViewController: BaseViewController<EventDetailView, EventDetailViewModel> {

    weak var delegate: EventDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

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
