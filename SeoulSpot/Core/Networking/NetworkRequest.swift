//
//  NetworkRequest.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import Foundation

// 서울시 문화행사 API 요청 파라미터 구성
struct CulturalEventRequestOption {
    var startIndex: Int = 1
    var endIndex: Int = 10
    var codeName: String? = nil
    var guName: String? = nil
    var title: String? = nil
}

// 문화행사 요청 타입 정의
enum NetworkRequest {
    case culturalEvents(option: CulturalEventRequestOption)

    // 서울시 열린데이터 API URL
    private var baseURL: String {
        return API.URL.seoulOpenAPIURL
    }

    // 인증키 (디코딩 키 필요)
    private var apiKey: String {
        return API.Key.seoulOpenAPIKey // 별도 Key 관리 필요
    }

    // 데이터셋 경로
    private var datasetPath: String {
        return "/\(apiKey)/json/culturalEventInfo"
    }

    // 최종 요청 URL 구성
    var endpoint: URL {
        switch self {
        case .culturalEvents(let option):
            let path = "\(datasetPath)/\(option.startIndex)/\(option.endIndex)"
            var components = URLComponents(string: baseURL + path)!

            var queryItems: [URLQueryItem] = []
            if let codeName = option.codeName {
                queryItems.append(URLQueryItem(name: "CODENAME", value: codeName))
            }
            if let guName = option.guName {
                queryItems.append(URLQueryItem(name: "GUNAME", value: guName))
            }
            if let title = option.title {
                queryItems.append(URLQueryItem(name: "TITLE", value: title))
            }
            components.queryItems = queryItems.isEmpty ? nil : queryItems
            return components.url!
        }
    }

    // HTTP 메서드
    var method: HTTPMethod {
        return .get
    }

    // 요청 헤더 (필요 시 추가)
    var headers: [String: String]? {
        return nil
    }

    // 파라미터 (GET 이므로 사용 안 함)
    var parameters: [String: Any]? {
        return nil
    }
}

// HTTPMethod 정의 (Alamofire 없이 사용)
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
