//
//  PinnedViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

protocol PinnedViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

final class PinnedViewController: BaseViewController<PinnedView, PinnedViewModel> {

    weak var delegate: PinnedViewControllerDelegate?

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
