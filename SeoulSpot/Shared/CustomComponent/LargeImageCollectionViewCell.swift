//
//  LargeImageCollectionViewCell.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit

final class LargeImageCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: LargeImageCollectionViewCell.self)

    private let imageView = UIImageView()
    private let categoryBadge = BadgeLabel(style: .theme)
    private let locationBadge = BadgeLabel(style: .location)
    private let isFreeBadge = BadgeLabel(style: .isFree)
    private let dateBadge = BadgeLabel(style: .date)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        categoryBadge.text = ""
        locationBadge.text = ""
        isFreeBadge.text = ""
        dateBadge.text = ""
    }
    
    private func setupHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(categoryBadge)
        contentView.addSubview(locationBadge)
        contentView.addSubview(isFreeBadge)
        contentView.addSubview(dateBadge)
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
        
        dateBadge.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView).inset(16)
            $0.height.equalTo(35)
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8

        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(with event: CulturalEventModel) {
        if let imageURL = URL(string: event.mainImage ?? "") {
            imageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
        }
        categoryBadge.text = event.codeName
        locationBadge.text = event.guName
        isFreeBadge.text = event.isFree
        isFreeBadge.backgroundColor = (event.isFree == "유료") ? .isPaidBadge : .isFreeBadge
        
        setDateBadge(event)
    }
    
    private func setDateBadge(_ event: CulturalEventModel) { // [TODO] DateFormatter 로 extension 빼두기
        if let start = event.startDate,
           let end = event.endDate {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E"
            let startString = formatter.string(from: start)
            
            if Calendar.current.isDate(start, inSameDayAs: end) {
                dateBadge.text = "\(startString)" // 하루
            } else {
                dateBadge.text = "\(startString) ~"
            }
            
        } else {
            dateBadge.text = nil
        }
    }
}
