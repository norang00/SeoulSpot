//
//  SearchMapView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import NMapsMap

class SearchMapView: BaseView {
    
    let mapView = NMFMapView(frame: .zero)
    
//    let searchBackground = UIView()
//    let searchTextField = UISearchTextField()
    
    override func setupHierarchy() {
        addSubview(mapView)

//        addSubview(searchBackground)
//        searchBackground.addSubview(searchTextField)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        searchBackground.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
//            $0.height.equalTo(44)
//        }
//        
//        searchTextField.snp.makeConstraints {
//            $0.verticalEdges.equalToSuperview().inset(4)
//            $0.horizontalEdges.equalToSuperview().inset(8)
//        }
    }

    override func setupView() {
        isUserInteractionEnabled = true
        
        backgroundColor = .white

//        searchBackground.backgroundColor = .white
//        searchBackground.layer.borderColor = UIColor.black.cgColor
//        searchBackground.layer.borderWidth = 1
//        searchBackground.layer.cornerRadius = 22
//
//        searchTextField.tintColor = .accent
//        searchTextField.backgroundColor = .white
//        searchTextField.layer.cornerRadius = 16
//        searchTextField.layer.masksToBounds = true
//        searchTextField.borderStyle = .none
    }
}
