//
//  CurationView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit

final class CurationView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let topBarView = UIView()
    let logoImageView = UIImageView()
    
    let mainTitleLabel = UILabel()
    let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let sub1TitleLabel = UILabel()
    let sub1CollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let sub2TitleLabel = UILabel()
    let sub2CollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let sub3TitleLabel = UILabel()
    let sub3CollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let emptyView = UIView()
    
    override func setupHierarchy() {
        addSubview(topBarView)
        topBarView.addSubview(logoImageView)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(mainCollectionView)
        
        contentView.addSubview(sub1TitleLabel)
        contentView.addSubview(sub1CollectionView)
        
        contentView.addSubview(sub2TitleLabel)
        contentView.addSubview(sub2CollectionView)
        
        contentView.addSubview(sub3TitleLabel)
        contentView.addSubview(sub3CollectionView)
        
        contentView.addSubview(emptyView)
    }
    
    override func setupLayout() {
        topBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalTo(topBarView)
            $0.bottom.equalTo(topBarView).inset(16)
            $0.height.equalTo(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.bottom.equalTo(emptyView.snp.bottom)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(8)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(44)
        }
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(390)
        }
        
        sub1TitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(44)
        }
        
        sub1CollectionView.snp.makeConstraints {
            $0.top.equalTo(sub1TitleLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(180)
        }
        
        sub2TitleLabel.snp.makeConstraints {
            $0.top.equalTo(sub1CollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(44)
        }
        
        sub2CollectionView.snp.makeConstraints {
            $0.top.equalTo(sub2TitleLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(180)
        }
        
        sub3TitleLabel.snp.makeConstraints {
            $0.top.equalTo(sub2CollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(44)
        }
        
        sub3CollectionView.snp.makeConstraints {
            $0.top.equalTo(sub3TitleLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(180)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(sub3CollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.greaterThanOrEqualTo(16)
            $0.bottom.equalTo(contentView)
        }
    }
    
    override func setupView() {
        topBarView.backgroundColor = .accent
        logoImageView.image = UIImage(named: "logoname_wh")
        logoImageView.contentMode = .scaleAspectFit
        
        backgroundColor = .white
        
        [mainTitleLabel].forEach {
            $0.font = .pretendardBold(ofSize: 22)
            $0.textColor = .label
            $0.backgroundColor = .clear
        }
        
        [sub1TitleLabel, sub2TitleLabel, sub3TitleLabel].forEach {
            $0.font = .pretendardBold(ofSize: 18)
            $0.textColor = .label
            $0.backgroundColor = .clear
        }
        
        mainTitleLabel.text = "곧 다가오는 행사✨"
        sub1TitleLabel.text = "전시/미술 관련 행사🎨"
        sub2TitleLabel.text = "코엑스에서 하는 행사🏬"
        sub3TitleLabel.text = "무료 행사👀"
        
        [mainCollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = createMainLayout()
            $0.alwaysBounceVertical = false
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
        }
        
        [sub1CollectionView, sub2CollectionView, sub3CollectionView].forEach {
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = createSubLayout()
        }
    }
    
    private func createMainLayout() -> UICollectionViewCompositionalLayout {
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
    
    private func createSubLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        return layout
    }
    
}
