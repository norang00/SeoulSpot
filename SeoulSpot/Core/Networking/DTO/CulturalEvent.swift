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
    let player: String?
    let program: String?
    let etcDesc: String?
    let orgLink: String?
    let mainImage: String?
    let rgstDate: String?
    let ticket: String?
    let startDate: String?
    let endDate: String?
    let themeCode: String?
    let lot: String?
    let lat: String?
    let isFree: String?
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case codeName = "CODENAME"
        case guName = "GUNAME"
        case title = "TITLE"
        case date = "DATE"
        case place = "PLACE"
        case orgName = "ORG_NAME"
        case useTarget = "USE_TRGT"
        case useFee = "USE_FEE"
        case player = "PLAYER"
        case program = "PROGRAM"
        case etcDesc = "ETC_DESC"
        case orgLink = "ORG_LINK"
        case mainImage = "MAIN_IMG"
        case rgstDate = "RGSTDATE"
        case ticket = "TICKET"
        case startDate = "STRTDATE"
        case endDate = "END_DATE"
        case themeCode = "THEMECODE"
        case lot = "LOT"
        case lat = "LAT"
        case isFree = "IS_FREE"
        case homepage = "HMPG_ADDR"
    }
}
