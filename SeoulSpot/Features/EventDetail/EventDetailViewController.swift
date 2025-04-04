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
        mainView.configure(with: viewModel.event, viewModel.getIsPinned())
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
            guard let self = self else { return }
            self.viewModel.togglePin()
            self.mainView.updatePinState(isPinned: self.viewModel.isPinned)
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
