//
//  CulturalEvent.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import Foundation

// 최상위 응답 모델
struct CulturalEventResponse: Decodable {
    let culturalEventInfo: CulturalEventInfo
}

// 실제 유효한 데이터가 들어있는 구조체
struct CulturalEventInfo: Decodable {
    let list_total_count: Int
    let RESULT: SeoulAPIResult?
    let row: [CulturalEvent]
}

struct SeoulAPIResult: Decodable {
    let CODE: String
    let MESSAGE: String
}

// 문화행사 개별 항목 모델
struct CulturalEvent: Decodable {
    let codeName: String
    let guName: String
    let title: String
    let date: String
    let place: String
    let orgName: String
    let useTarget: String?
    let useFee: String?
    let orgLink: String?
    let mainImage: String?
    let homepage: String?
    let isFree: String?
    let lot: String?
    let lat: String?

    enum CodingKeys: String, CodingKey {
        case codeName = "CODENAME"
        case guName = "GUNAME"
        case title = "TITLE"
        case date = "DATE"
        case place = "PLACE"
        case orgName = "ORG_NAME"
        case useTarget = "USE_TRGT"
        case useFee = "USE_FEE"
        case orgLink = "ORG_LINK"
        case mainImage = "MAIN_IMG"
        case homepage = "HMPG_ADDR"
        case isFree = "IS_FREE"
        case lot = "LOT"
        case lat = "LAT"
    }
}

extension CulturalEvent {
    /// CulturalEvent.date 값에서 시작일만 추출 → Date 변환
    var toEventStartDate: Date? {
        let startDateStr = date.components(separatedBy: "~").first?.trimmingCharacters(in: .whitespaces)
        return Date.from(dateString: startDateStr ?? "")
    }

    /// CulturalEvent.date 값에서 종료일만 추출 → Date 변환
    var toEventEndDate: Date? {
        let parts = date.components(separatedBy: "~")
        guard parts.count > 1 else { return nil }
        let endDateStr = parts[1].trimmingCharacters(in: .whitespaces)
        return Date.from(dateString: endDateStr)
    }
}
