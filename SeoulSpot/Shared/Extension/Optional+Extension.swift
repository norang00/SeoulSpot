//
//  Optional+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/5/25.
//

import Foundation

extension Optional where Wrapped == String {
    var orDash: String {
        if let value = self, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return value
        } else {
            return "-"
        }
    }
}
