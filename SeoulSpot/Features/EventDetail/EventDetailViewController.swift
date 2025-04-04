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
        
        setupNavigationView()
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

    private func setupNavigationView() {
        // 네비게이션 바 투명 처리
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        // 백 버튼은 기본 스타일 유지
        navigationItem.title = ""
        navigationItem.backButtonTitle = ""
    }
}
