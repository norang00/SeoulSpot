//
//  EventDetailViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import Combine

final class EventDetailViewController: BaseViewController<EventDetailView, EventDetailViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationView()
        baseView.configure(with: viewModel.event, viewModel.isPinned)
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
        
        viewModel.$isPinned
            .receive(on: RunLoop.main)
            .sink { [weak self] isPinned in
                self?.baseView.updatePinState(isPinned: isPinned)
            }
            .store(in: &cancellables)
        
        baseView.onPinTapped = { [weak self] in
            self?.viewModel.togglePin()
        }
    }

    private func setupNavigationView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        navigationItem.title = ""
        navigationItem.backButtonTitle = ""
    }
}
