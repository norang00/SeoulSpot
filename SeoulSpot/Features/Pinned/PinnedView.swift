//
//  PinnedView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit

final class PinnedView: BaseView {

//    let sortButton = UIButton(type: .system)
    let tableView = UITableView(frame: .zero, style: .plain)

    override func setupHierarchy() {
//        addSubview(sortButton)
        addSubview(tableView)
    }

    override func setupLayout() {
//        sortButton.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.width.height.equalTo(24)
//        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupView() {
        backgroundColor = .white

//        sortButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
//        sortButton.tintColor = .label

        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
