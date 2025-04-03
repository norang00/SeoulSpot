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

    let emptyView = UIView()
    
    override func setupHierarchy() {
        addSubview(mainTitleLabel)
        addSubview(mainCollectionView)

        addSubview(subTitleLabel)
        addSubview(subCollectionView)
        
        addSubview(emptyView)
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
            $0.height.equalTo(390)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        subCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(subCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    override func setupView() {
        backgroundColor = .white

        [mainTitleLabel].forEach {
            $0.font = .pretendardBold(ofSize: 22)
            $0.textColor = .label
            $0.backgroundColor = .clear
        }

        [subTitleLabel].forEach {
            $0.font = .pretendardBold(ofSize: 18)
            $0.textColor = .label
            $0.backgroundColor = .clear
        }

        mainTitleLabel.text = "곧 다가오는 행사✨"
        subTitleLabel.text = "전시/미술 관련 행사🎨"
        
        [mainCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceVertical = false
            $0.collectionViewLayout = createLayout()
        }

        [subCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 120, height: 180)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 16
            $0.collectionViewLayout = layout
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(260),
            heightDimension: .absolute(390)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
