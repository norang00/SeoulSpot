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
        
        setupTableView()
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

extension PinnedViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(BasicInfoTableViewCell.self, forCellReuseIdentifier: BasicInfoTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicInfoTableViewCell.identifier, for: indexPath) as! BasicInfoTableViewCell
        return cell
    }
    
}
