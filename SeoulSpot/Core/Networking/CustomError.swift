//
//  CustomError.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import Foundation

enum CustomError: Error {
    // 일반 네트워크 오류
    case noInternet
    case decodingFailed
    case serverIssue
    case askAdmin
    case unknown

    // 서울 열린데이터 광장 API 전용 오류 코드
    case info001  // 해당하는 데이터가 없습니다
    case info002  // 요청인자가 누락되었습니다
    case info003  // 유효하지 않은 요청 인자입니다
    case error500 // 서버 오류

    var localizedDescription: String {
        switch self {
        case .noInternet:
            return "인터넷 연결이 끊어졌습니다."
        case .decodingFailed:
            return "데이터를 해석하는 데 실패했습니다."
        case .serverIssue:
            return "서버 내부 오류가 발생했습니다."
        case .askAdmin:
            return "알 수 없는 오류입니다. 관리자에게 문의해주세요."
        case .unknown:
            return "예기치 못한 오류가 발생했습니다."
        case .info001:
            return "해당하는 데이터가 없습니다."
        case .info002:
            return "요청 인자가 누락되었습니다."
        case .info003:
            return "유효하지 않은 요청 인자입니다."
        case .error500:
            return "서버 오류가 발생했습니다."
        }
    }

    // 서울 열린데이터 API의 코드(String)를 CustomError로 매핑
    static func fromSeoulAPICode(_ code: String) -> CustomError {
        switch code.uppercased() {
        case "INFO-001": return .info001
        case "INFO-002": return .info002
        case "INFO-003": return .info003
        case "ERROR-500": return .error500
        default: return .unknown
        }
    }
}
