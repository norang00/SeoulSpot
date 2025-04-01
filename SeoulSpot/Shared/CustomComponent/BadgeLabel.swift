//
//  BadgeLabel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import UIKit

final class BadgeLabel: UILabel {

enum BadgeStyle {
    case location
    case category
    case free
    case paid

    var backgroundColor: UIColor {
        switch self {
        case .location: return .orange
        case .category: return .systemBlue
        case .free: return .systemGreen
        case .paid: return .systemRed
        }
    }

    var textColor: UIColor {
        return .white
    }
}

init(style: BadgeStyle) {
    super.init(frame: .zero)
    setupStyle(style: style)
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupStyle(style: .location) // default
}

private func setupStyle(style: BadgeStyle) {
    font = .pretendardBold(ofSize: 14)
    textAlignment = .center
    textColor = style.textColor
    backgroundColor = style.backgroundColor
    layer.cornerRadius = 15
    clipsToBounds = true
    setContentHuggingPriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .horizontal)
}

override var intrinsicContentSize: CGSize {
    let superSize = super.intrinsicContentSize
    return CGSize(width: superSize.width + 16, height: superSize.height + 8)
}
}
