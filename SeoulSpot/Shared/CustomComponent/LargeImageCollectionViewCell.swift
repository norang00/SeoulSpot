//
//  LargeImageCollectionViewCell.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit
/* [TODO]
 - 그림자 효과
 */
final class LargeImageCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: LargeImageCollectionViewCell.self)

    private let imageView = UIImageView()
    private let categoryBadge = BadgeLabel(style: .theme)
    private let locationBadge = BadgeLabel(style: .location)
    private let isFreeBadge = BadgeLabel(style: .isFree)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(categoryBadge)
        contentView.addSubview(locationBadge)
        contentView.addSubview(isFreeBadge)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(50)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).inset(10)
        }

        categoryBadge.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).inset(10)
            $0.height.equalTo(30)
        }
        
        locationBadge.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.leading.equalTo(categoryBadge.snp.trailing).offset(6)
            $0.height.equalTo(30)
        }
        
        isFreeBadge.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.leading.equalTo(locationBadge.snp.trailing).offset(6)
            $0.height.equalTo(30)
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .bgGray
        contentView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(with event: CulturalEvent) {
        if let imageURL = URL(string: event.mainImage ?? "") {
            imageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
        }
        categoryBadge.text = event.codeName
        locationBadge.text = event.guName
        isFreeBadge.text = event.isFree
    }
}
