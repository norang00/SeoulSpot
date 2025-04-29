//
//  EventFilter.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/10/25.
//

import Foundation

// MARK: - 문화행사 분류
enum EventCategory: String, CaseIterable {
    case exhibitionArt = "전시/미술"
    case educationExperience = "교육/체험"
    case classic = "클래식"
    case dance = "무용"
    case theater = "연극"
    case traditionalMusic = "국악"
    case musicalOpera = "뮤지컬/오페라"
    case movie = "영화"
    case concert = "콘서트"
    case soloRecital = "독주/독창회"
    case festival = "축제"
    case unknown = "기타"
}

// MARK: - 자치구 분류
enum District: String, CaseIterable {
    case gangnam = "강남구"
    case gangdong = "강동구"
    case gangbuk = "강북구"
    case gangseo = "강서구"
    case geumcheon = "금천구"
    case gwanak = "관악구"
    case gwangjin = "광진구"
    case guro = "구로구"
    case jungnang = "중랑구"
    case jung = "중구"
    case dobong = "도봉구"
    case dongdaemun = "동대문구"
    case dongjak = "동작구"
    case mapo = "마포구"
    case nowon = "노원구"
    case seodaemun = "서대문구"
    case seocho = "서초구"
    case seongbuk = "성북구"
    case seongdong = "성동구"
    case songpa = "송파구"
    case yangcheon = "양천구"
    case yeongdeungpo = "영등포구"
    case yongsan = "용산구"
    case eunpyeong = "은평구"
    case jongno = "종로구"
    case unknown = "기타"
}

// MARK: - 유/무료 분류
enum PriceType: String, CaseIterable {
    case free = "무료"
    case paid = "유료"
    case unknown = "기타"
}

// MARK: - 관람 대상 분류
enum AudienceTarget: String, CaseIterable {
    case everyone = "관심있는 누구나"
    case students = "학생 대상"
    case children = "어린이/청소년"
    case preschool = "영유아/유아"
    case adultsOnly = "성인 전용"
    case groupOnly = "단체 전용"
    case unknown = "기타"

    var displayName: String {
        switch self {
        case .everyone: return "누구나"
        case .students: return "학생"
        case .children: return "어린이/청소년"
        case .preschool: return "유아/영유아"
        case .adultsOnly: return "성인"
        case .groupOnly: return "단체"
        case .unknown: return "기타"
        }
    }
}

// MARK: - 관람 대상 자동 분류 유틸
extension AudienceTarget {
    static func from(_ text: String) -> AudienceTarget {
        let lowercased = text.lowercased()
        if lowercased.contains("누구나") || lowercased.contains("전체") || lowercased.contains("관심") {
            return .everyone
        } else if lowercased.contains("청소년") || lowercased.contains("초등") || lowercased.contains("중고등") {
            return .children
        } else if lowercased.contains("단체") {
            return .groupOnly
        } else if lowercased.contains("48개월") || lowercased.contains("36개월") {
            return .preschool
        } else if lowercased.contains("성인") {
            return .adultsOnly
        } else {
            return .unknown
        }
    }
}
