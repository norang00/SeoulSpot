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
    
    func togglePin() {
        if isPinned {
            CoreDataManager.shared.deleteEvent(event)
        } else {
            CoreDataManager.shared.saveEvent(event)
        }
        isPinned.toggle()
    }
}
