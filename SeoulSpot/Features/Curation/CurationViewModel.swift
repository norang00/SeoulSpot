//
//  CurationViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class CurationViewModel: BaseViewModel {
    
    @Published var allEvents: [CulturalEvent] = []
    @Published var mainItems: [CulturalEvent] = []
    @Published var subItems: [CulturalEvent] = []
    
    override init() {
        super.init()
        fetchEvents()
    }
    
    private func fetchEvents() {
        isLoading = true
        
        let option = CulturalEventRequestOption(startIndex: 1, endIndex: 100)
        let request = NetworkRequest.culturalEvents(option: option)
        
        //[TODO] Collection 별로 별도 쿼리 보내기
        NetworkManager.shared.callRequestToAPIServer(request, CulturalEventResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    guard let code = response.culturalEventInfo.RESULT?.CODE,
                          code == "INFO-000" else {
                        self?.errorMessage.send("API 오류")
                        return
                    }
                    
                    let events = response.culturalEventInfo.row
                    
                    self?.allEvents = events
                    self?.applyFilters(from: events)
                    
                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            }
        }
    }
    
    private func applyFilters(from events: [CulturalEvent]) {
        let calendar = Calendar.current
        let today = Date()
        let twoWeeksLater = calendar.date(byAdding: .day, value: 14, to: today)!
        
        mainItems = events.filter {
            guard let startDate = $0.toEventStartDate else { return false }
            return (today...twoWeeksLater).contains(startDate)
        }
        
        subItems = events.filter { $0.codeName == "전시/미술" }
    }
}
