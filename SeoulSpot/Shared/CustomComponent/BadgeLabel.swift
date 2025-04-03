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
    case theme
    case isFree
    case date

    var backgroundColor: UIColor {
        switch self {
        case .location: return .locationBadge
        case .theme: return .themeBadge
        case .isFree: return .isFreeBadge
        case .date: return .black
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
