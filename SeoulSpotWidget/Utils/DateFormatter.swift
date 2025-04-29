//
//  DateFormatter.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/23/25.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")  // 필요 시 명시
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
}
