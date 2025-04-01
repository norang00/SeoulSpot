//
//  BaseView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupLayout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 뷰 위계 구성
    func setupHierarchy() {
        fatalError("override 필수")
    }
        
    /// 오토레이아웃 구성
    
    func setupLayout() {
        fatalError("override 필수")
    }
    
    /// 뷰 설정 (배경색, 컴포넌트 추가 등)
    func setupView() {
        fatalError("override 필수")
    }
}
