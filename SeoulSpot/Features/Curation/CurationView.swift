//
//  CurationView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit

final class CurationView: BaseView {

    let mainTitleLabel = UILabel()
    let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let subTitleLabel = UILabel()
    let subCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func setupHierarchy() {
        addSubview(mainTitleLabel)
        addSubview(mainCollectionView)

        addSubview(subTitleLabel)
        addSubview(subCollectionView)
    }

    override func setupLayout() {
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(360)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        subCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(200)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }

    override func setupView() {
        backgroundColor = .white

        [mainTitleLabel, subTitleLabel].forEach {
            $0.font = .pretendardBold(ofSize: 20)
            $0.textColor = .label
            $0.backgroundColor = .clear
        }
        mainTitleLabel.text = "곧 다가오는 행사"
        subTitleLabel.text = "전시/미술 관련 행사"
        
        [mainCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 240, height: 360)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 16
            $0.collectionViewLayout = layout
        }

        [subCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 130, height: 200)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 16
            $0.collectionViewLayout = layout
        }
    }
}
