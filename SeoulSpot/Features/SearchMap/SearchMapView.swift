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
    let currentLocationButton = UIButton()
//    let searchBackground = UIView()
//    let searchTextField = UISearchTextField()
    
    override func setupHierarchy() {
        addSubview(mapView)
        addSubview(currentLocationButton)

//        addSubview(searchBackground)
//        searchBackground.addSubview(searchTextField)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(44)
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
        
        currentLocationButton.layer.cornerRadius = 22
        currentLocationButton.backgroundColor = .white
        currentLocationButton.tintColor = .accent
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        
        currentLocationButton.layer.shadowColor = UIColor.black.cgColor
        currentLocationButton.layer.shadowOpacity = 0.2
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentLocationButton.layer.shadowRadius = 4

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
