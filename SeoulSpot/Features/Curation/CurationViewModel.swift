//
//  CurationViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class CurationViewModel: BaseViewModel {
    
    @Published var mainItems: [CulturalEventModel] = [] // 2주 내 시작 이벤트
    @Published var subItems: [CulturalEventModel] = [] // [전시/미술] 테마 이벤트
    
    override init() {
        super.init()
        
        fetchMainEvents()
        fetchSubEvents()
    }
    
    private func fetchMainEvents() {
        print(#function)
        isLoading = true

        let today = Date()
        guard let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today) else {
            isLoading = false
            return
        }
        
        let filteredEntities = CoreDataManager.shared.fetchEvents(startingFrom: today, to: twoWeeksLater)
        mainItems = filteredEntities.shuffled()
        
        dump(mainItems)
    }
    
    private func fetchSubEvents() {
        print(#function)
        isLoading = true
        
        let filteredEntities = CoreDataManager.shared.fetchEvents(codeName: CodeName.exhibition.rawValue)
        subItems = filteredEntities.shuffled()

        isLoading = false
    }

}
