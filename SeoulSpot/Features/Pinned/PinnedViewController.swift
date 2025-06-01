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
            .sink { [weak self] value in
                self?.baseView.emptyLabel.isHidden = !value.isEmpty
                self?.baseView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension PinnedViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = self
        baseView.tableView.register(BasicInfoTableViewCell.self, forCellReuseIdentifier: BasicInfoTableViewCell.identifier)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = viewModel.pinnedEvents[indexPath.row]
            let alert = UIAlertController(title: "삭제 확인", message: "저장한 이벤트를 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.removePinnedEvent(event)
                tableView.deleteRows(at: [indexPath], with: .left)
            }))
            present(alert, animated: false, completion: nil)
        }
    }
}
