//
//  CurationViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class CurationViewModel: BaseViewModel {
    
    @Published var mainItems: [CulturalEvent] = [] // 2주 내 시작 이벤트
    @Published var subItems: [CulturalEvent] = [] // [전시/미술] 테마 이벤트
    
    override init() {
        super.init()
        
        fetchMainEvents()
        fetchSubEvents()
    }
    
    private func fetchMainEvents() {
        isLoading = true

        let option = CulturalEventRequestOption(startIndex: 1, endIndex: 100)
        let request = NetworkRequest.culturalEvents(option: option)

        NetworkManager.shared.callRequestToAPIServer(request, CulturalEventResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                print(#function, request.endpoint.absoluteURL)
                
                switch result {
                case .success(let response):
                    guard response.culturalEventInfo.RESULT?.CODE == "INFO-000" else {
                        self?.errorMessage.send("메인 이벤트 요청 실패")
                        return
                    }

                    let today = Date()
                    let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today)!

                    let events = response.culturalEventInfo.row.filter {
                        guard let start = $0.toEventStartDate else { return false }
                        return (today...twoWeeksLater).contains(start)
                    }

                    self?.mainItems = Array(events.prefix(10)).shuffled() // 최대 10개

                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchSubEvents() {
        let option = CulturalEventRequestOption(startIndex: 1, endIndex: 10, codeName: "전시/미술") // 쿼리로 전달
        let request = NetworkRequest.culturalEvents(option: option)

        NetworkManager.shared.callRequestToAPIServer(request, CulturalEventResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                
                print(#function, request.endpoint.absoluteURL)

                switch result {
                case .success(let response):
                    guard response.culturalEventInfo.RESULT?.CODE == "INFO-000" else {
                        self?.errorMessage.send("서브 이벤트 요청 실패")
                        return
                    }

                    self?.subItems = response.culturalEventInfo.row.shuffled()

                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            }
        }
    }

}
