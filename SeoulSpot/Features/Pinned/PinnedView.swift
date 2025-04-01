//
//  PinnedView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class PinnedView: BaseView {
    
    let tableView = UITableView()
    
    override func setupHierarchy() {
        addSubview(tableView)
    }
    
    override func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override func setupView() {
        print(#function)
    }
}
