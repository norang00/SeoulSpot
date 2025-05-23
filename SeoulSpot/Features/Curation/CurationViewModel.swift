//
//  CurationViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class CurationViewModel: BaseViewModel {
    
    @Published var mainItems: [CulturalEventModel] = [] // 2주 내 시작 이벤트
    @Published var sub1Items: [CulturalEventModel] = [] // [전시/미술] 테마 이벤트
    @Published var sub2Items: [CulturalEventModel] = [] // [강남구] 테마 이벤트
    @Published var sub3Items: [CulturalEventModel] = [] // [무료] 테마 이벤트

    override init() {
        super.init()
        
        fetchMainEvents()
        fetchSub1Events()
        fetchSub2Events()
        fetchSub3Events()
    }
    
    private func fetchMainEvents() {
        print(#function)
        isLoading = true

        let today = Date()
        let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today)
        
        let filters: [FilterOption] = [
            .dateRange(today, twoWeeksLater ?? today)
        ]
        let filteredEvents = CoreDataManager.shared.fetchEvents(with: filters)
        mainItems = filteredEvents

        isLoading = false
    }
    
    private func fetchSub1Events() {
        print(#function)
        isLoading = true
        
        let filters: [FilterOption] = [
            .codeName(CodeName.exhibition.rawValue)
        ]
        let filteredEvents = CoreDataManager.shared.fetchEvents(with: filters)
        sub1Items = filteredEvents.shuffled()

        isLoading = false
    }
    
    private func fetchSub2Events() {
        print(#function)
        isLoading = true

        let filters: [FilterOption] = [
            .guName("강남")
        ]
        let filteredEvents = CoreDataManager.shared.fetchEvents(with: filters)
        sub2Items = filteredEvents.shuffled()
        
        isLoading = false
    }
    
    private func fetchSub3Events() {
        print(#function)
        isLoading = true

        let filters: [FilterOption] = [
            .isFree
        ]
        let filteredEvents = CoreDataManager.shared.fetchEvents(with: filters)
        sub3Items = filteredEvents.shuffled()
        
        isLoading = false
    }

}
