//
//  SmallImageCollectionViewCell.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit

final class SmallImageCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: SmallImageCollectionViewCell.self)
    
    let imageView = UIImageView()

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
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    private func setupView() {
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(with event: CulturalEvent) {
        if let imageURL = URL(string: event.mainImage ?? "") {
            imageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
        }
    }
}
