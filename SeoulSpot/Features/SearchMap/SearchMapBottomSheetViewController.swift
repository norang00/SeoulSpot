//
//  SearchMapBottomSheetViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/2/25.
//

import UIKit

final class SearchMapBottomSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "여기 검색 결과 리스트 구성 예정"
        label.textAlignment = .center

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]         // 시트 높이 단계
            sheet.prefersGrabberVisible = true            // 그래버 표시
            sheet.preferredCornerRadius = 16              // 코너 둥글게
        }
    }
}
