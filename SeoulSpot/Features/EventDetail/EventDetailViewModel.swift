//
//  EventDetailViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation

final class EventDetailViewModel: BaseViewModel {
    
    let event: CulturalEvent

    init(event: CulturalEvent) {
        self.event = event
        super.init()
    }
}
