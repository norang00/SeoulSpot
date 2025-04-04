//
//  String+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/4/25.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}
