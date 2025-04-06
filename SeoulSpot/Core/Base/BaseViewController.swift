//
//  BaseViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import Combine

class BaseViewController<ViewType: BaseView, ViewModelType: BaseViewModel>: UIViewController {
    
    // MARK: - View
    var baseView: ViewType {
        guard let view = self.view as? ViewType else {
            fatalError("\(ViewType.self) 타입 캐스팅 실패")
        }
        return view
    }
    
    // MARK: - ViewModel
    var viewModel: ViewModelType!
    
    init(viewModel: ViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindViewModel() {
        fatalError("override 필수")
    }

    // MARK: - Life Cycle

    var cancellables = Set<AnyCancellable>()

    override func loadView() {
        self.view = ViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismissOnTap()
        
        bindViewModel()
    }

    deinit {
        cancellables.removeAll()
        print("Deinit: \(type(of: self))")
    }

    // MARK: - Common Features

    func showLoading(_ show: Bool) {
        // 공통 로딩 처리
    }

    func showError(_ message: String) {
        // 공통 에러 처리
    }

    func keyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }
}
