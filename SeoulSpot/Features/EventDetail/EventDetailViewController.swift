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
        
        
        mainView.onPinTapped = { [weak self] in
            self?.viewModel.togglePin()
        }

        viewModel.$isPinned
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPinned in
                self?.mainView.updatePinState(isPinned: isPinned)
            }
            .store(in: &cancellables)
    }

}
