//
//  EventDetailViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class EventDetailViewController: BaseViewController<EventDetailView, EventDetailViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(with: viewModel.event)
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
