//
//  NetworkManager.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private init() { }

    // 테스트용: 응답 전체를 문자열로 출력하는 메서드
    func testCallRequestToAPIServer<T: Decodable>(_ api: NetworkRequest,
                                                  _ type: T.Type,
                                                  completionHandler: @escaping (Result<T, CustomError>) -> Void) {
        var request = URLRequest(url: api.endpoint)
        request.httpMethod = api.method.rawValue

        // 파라미터 설정
        if let parameters = api.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        // 헤더 설정
        api.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // 요청 실행 및 문자열 출력
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print("\n===== Response String =====")
                print(string)
                print("===========================\n")
            }
        }.resume()
    }

    // 실제 API 요청 및 Decodable 파싱
    func callRequestToAPIServer<T: Decodable>(_ api: NetworkRequest,
                                              _ type: T.Type,
                                              completionHandler: @escaping (Result<T, CustomError>) -> Void) {
        var request = URLRequest(url: api.endpoint)
        request.httpMethod = api.method.rawValue

        // 파라미터 설정
        if let parameters = api.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        // 헤더 설정
        api.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        

        print(#function, request)

        // URLSession 요청 실행
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 네트워크 오류 처리
            if let error = error {
                completionHandler(.failure(self.handleError(response: response, error: error)))
                return
            }

            // 응답 데이터 확인
            guard let data = data else {
                completionHandler(.failure(.unknown))
                return
            }

            // JSON 디코딩 시도
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decoded))
            } catch {
                print("디코딩 실패: \(error)")
                completionHandler(.failure(.decodingFailed))
            }
        }.resume()
    }

    // 오류 처리 메서드
    private func handleError(response: URLResponse?, error: Error) -> CustomError {
        // URL 에러 유형 확인
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternet
            default:
                break
            }
        }

        // HTTP 상태 코드에 따른 분기
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 500:
                return .serverIssue
            default:
                return .askAdmin
            }
        }

        // 알 수 없는 오류
        return .unknown
    }
}
