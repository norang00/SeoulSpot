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
    
    private let badgeStackView = UIStackView()
    private let categoryBadge = BadgeLabel(style: .theme)
    private let locationBadge = BadgeLabel(style: .location)
    private let isFreeBadge = BadgeLabel(style: .isFree)
    
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

    // MARK: - Hierarchy
    private func setupHierarchy() {
        contentView.addSubview(borderView)

        badgeStackView.addArrangedSubview(categoryBadge)
        badgeStackView.addArrangedSubview(locationBadge)
        badgeStackView.addArrangedSubview(isFreeBadge)

        badgeStackView.axis = .horizontal
        badgeStackView.spacing = 4
        badgeStackView.alignment = .leading
        
        borderView.addSubview(badgeStackView)

        let infoStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, dateLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4

        let mainStack = UIStackView(arrangedSubviews: [thumbnailImageView, infoStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .top

        borderView.addSubview(mainStack)
    }

    // MARK: - Layout
    private func setupLayout() {
        borderView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }

        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }

        badgeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(24)
        }

        if let mainStack = borderView.subviews.last {
            mainStack.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(12)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
        }
    }

    // MARK: - View Settings
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = 12
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.systemGray4.cgColor
        borderView.clipsToBounds = true

        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.backgroundColor = .systemGray5

        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel
    }

    // MARK: - Configure
    func configure(with event: CulturalEvent) {
        titleLabel.text = event.title
        subtitleLabel.text = event.place
        dateLabel.text = event.date
        
        if let imageURL = URL(string: event.mainImage ?? "") {
            thumbnailImageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
        }
        
        categoryBadge.text = event.codeName
        locationBadge.text = event.guName
        isFreeBadge.text = event.isFree
    }
}
