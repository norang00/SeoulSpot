//
//  EventDetailViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class EventDetailViewModel: BaseViewModel {
        
    let event: CulturalEventModel
    @Published var isPinned: Bool = false

    init(event: CulturalEventModel) {
        self.event = event
        super.init()
        checkPinnedStatus()
    }
    
    func checkPinnedStatus() {
        isPinned = CoreDataManager.shared.isEventPinned(event)
    }
    
    func togglePin() {
        if isPinned {
            CoreDataManager.shared.unpinEvent(event)
        } else {
            CoreDataManager.shared.pinEvent(event)
        }
        isPinned.toggle()
    }
}
