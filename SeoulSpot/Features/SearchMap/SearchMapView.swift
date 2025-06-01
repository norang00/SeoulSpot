//
//  SearchMapView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import NMapsMap
import Toast

class SearchMapView: BaseView {
    
    let mapView = NMFMapView(frame: .zero)
    let filterButton = UIButton()
    let currentLocationButton = UIButton()

    lazy var resultCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: setupLayout())
    
    override func setupHierarchy() {
        addSubview(mapView)
        addSubview(filterButton)
        addSubview(currentLocationButton)
        addSubview(resultCollectionView)
    }
        
    override func setupLayout() {
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        resultCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }

        filterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }

        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(filterButton.snp.bottom).offset(12)
            $0.size.equalTo(40)
        }
    }

    override func setupView() {
        isUserInteractionEnabled = true
        backgroundColor = .clear
        
        filterButton.layer.cornerRadius = 20
        filterButton.backgroundColor = .white
        filterButton.tintColor = .accent
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 4
        
        currentLocationButton.layer.cornerRadius = 20
        currentLocationButton.backgroundColor = .white
        currentLocationButton.tintColor = .accent
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        
        currentLocationButton.layer.shadowColor = UIColor.black.cgColor
        currentLocationButton.layer.shadowOpacity = 0.2
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentLocationButton.layer.shadowRadius = 4

        resultCollectionView.isHidden = true
        resultCollectionView.isPagingEnabled = true
        resultCollectionView.showsHorizontalScrollIndicator = false
        resultCollectionView.backgroundColor = .clear
        resultCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        resultCollectionView.clipsToBounds = true
    }
    
    private func setupLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    }
}
