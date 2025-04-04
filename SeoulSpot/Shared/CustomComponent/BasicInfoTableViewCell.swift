//
//  BasicInfoTableViewCell.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/3/25.
//

import UIKit
import SnapKit
final class BasicInfoTableViewCell: UITableViewCell {

    static let identifier = String(describing: BasicInfoTableViewCell.self)

    private let borderView = UIView()
    private let thumbnailImageView = UIImageView()
    
    private let categoryBadge = BadgeLabel(style: .theme)
    private let locationBadge = BadgeLabel(style: .location)
    private let isFreeBadge = BadgeLabel(style: .isFree)
    
    private let infoStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupLayout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryBadge.text = ""
        locationBadge.text = ""
        isFreeBadge.text = ""
        titleLabel.text = ""
        subtitleLabel.text = ""
        dateLabel.text = ""
        thumbnailImageView.image = UIImage(named: "placeholder")
    }

    // MARK: - Hierarchy
    private func setupHierarchy() {
        contentView.addSubview(borderView)

        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
        infoStackView.addArrangedSubview(dateLabel)
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        
        borderView.addSubview(thumbnailImageView)
        borderView.addSubview(categoryBadge)
        borderView.addSubview(locationBadge)
        borderView.addSubview(isFreeBadge)
        borderView.addSubview(infoStackView)
    }

    // MARK: - Layout
    private func setupLayout() {
        borderView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.verticalEdges.equalTo(contentView).inset(6)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalTo(borderView).inset(12)
            $0.verticalEdges.equalTo(borderView).inset(12)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        
        categoryBadge.snp.makeConstraints {
            $0.top.equalTo(borderView).inset(12)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.height.equalTo(30)
        }

        locationBadge.snp.makeConstraints {
            $0.top.equalTo(borderView).inset(12)
            $0.leading.equalTo(categoryBadge.snp.trailing).offset(8)
            $0.height.equalTo(30)
        }

        isFreeBadge.snp.makeConstraints {
            $0.top.equalTo(borderView).inset(12)
            $0.leading.equalTo(locationBadge.snp.trailing).offset(8)
            $0.height.equalTo(30)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.top.equalTo(categoryBadge.snp.bottom).offset(8)
            $0.bottom.trailing.equalTo(borderView).inset(12)
        }

    }

    // MARK: - View Settings
    private func setupView() {
        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = 8
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.gray.cgColor
        borderView.clipsToBounds = true

        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.backgroundColor = .bgGray
        
        categoryBadge.setContentHuggingPriority(.required, for: .horizontal)
        categoryBadge.setContentCompressionResistancePriority(.required, for: .horizontal)

        locationBadge.setContentHuggingPriority(.required, for: .horizontal)
        locationBadge.setContentCompressionResistancePriority(.required, for: .horizontal)

        isFreeBadge.setContentHuggingPriority(.required, for: .horizontal)
        isFreeBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

    }

    // MARK: - Configure
    func configure(with event: CulturalEvent) {        
        categoryBadge.text = event.codeName
        locationBadge.text = event.guName
        isFreeBadge.text = event.isFree
        
        titleLabel.text = event.title
        subtitleLabel.text = event.place
        dateLabel.text = event.date
        
        if let imageURL = URL(string: event.mainImage ?? "") {
            thumbnailImageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
        }
    }
}
