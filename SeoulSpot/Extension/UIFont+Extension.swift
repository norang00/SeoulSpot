//
//  UIFont+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

extension UIFont {
    static func pretendardRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func pretendardMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func pretendardBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static var titleFont: UIFont {
        return UIFont.pretendardBold(ofSize: 16)
    }
    
    static var bodyFont: UIFont {
        return UIFont.pretendardRegular(ofSize: 12)
    }
    
    static var captionFont: UIFont {
        return UIFont.pretendardMedium(ofSize: 10)
    }
    
}
