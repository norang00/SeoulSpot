//
//  PinnedViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import Combine

protocol PinnedViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: CulturalEventModel)
}

final class PinnedViewController: BaseViewController<PinnedView, PinnedViewModel> {

    var delegate: PinnedViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "저장한 이벤트📌"

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchPinnedEvents()
    }

    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showLoading($0) }
            .store(in: &cancellables)

        viewModel.errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showError($0) }
            .store(in: &cancellables)
        
        viewModel.$pinnedEvents
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.curationView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension PinnedViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        curationView.tableView.delegate = self
        curationView.tableView.dataSource = self
        curationView.tableView.register(BasicInfoTableViewCell.self, forCellReuseIdentifier: BasicInfoTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pinnedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicInfoTableViewCell.identifier, for: indexPath) as! BasicInfoTableViewCell
        let event = viewModel.pinnedEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent: CulturalEventModel
        selectedEvent = viewModel.pinnedEvents[indexPath.row]
        delegate?.didSelectEvent(selectedEvent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
