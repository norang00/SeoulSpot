//
//  CulturalEventModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/4/25.
//

import Foundation

struct CulturalEventModel {
    let codeName: String?
    let guName: String?
    let title: String?
    let date: String?
    let place: String?
    let orgName: String?
    let useTarget: String?
    let useFee: String?
    let player: String?
    let program: String?
    let etcDesc: String?
    let orgLink: String?
    let mainImage: String?
    let rgstDate: String?
    let ticket: String?
    let startDate: Date?
    let endDate: Date?
    let themeCode: String?
    let lot: Double?
    let lat: Double?
    let isFree: String?
    let homepage: String?
}

extension CulturalEventModel {
    var id: String {
        return "\(title ?? "")_\(lat ?? 0)_\(lot ?? 0)"
    }
}

extension CulturalEventModel {
    var isEnded: Bool {
        guard let end = self.endDate else { return false }
        return end < Date()
    }
}

enum CodeName: String {
    case exhibition = "전시/미술"
    case play = "연극"
    case education = "교육/체험"
}
