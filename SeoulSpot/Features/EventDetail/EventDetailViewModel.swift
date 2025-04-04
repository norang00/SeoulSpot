//
//  EventDetailViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class EventDetailViewModel: BaseViewModel {
        
    let event: CulturalEvent
    @Published var isPinned: Bool = false

    init(event: CulturalEvent) {
        self.event = event
        super.init()
    }
    
    func getIsPinned() -> Bool {
        isPinned = CoreDataManager.shared.isEventPinned(event)
        return isPinned
    }
    
    func togglePin() {
        if isPinned {
            CoreDataManager.shared.deleteEvent(event)
            isPinned = false
        } else {
            CoreDataManager.shared.saveEvent(event)
            isPinned = true
        }
    }
}
