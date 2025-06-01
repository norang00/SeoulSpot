//
//  PinnedViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation
import Combine

final class PinnedViewModel: BaseViewModel {

    @Published var pinnedEvents: [CulturalEventModel] = []

    override init() {
        super.init()
        fetchPinnedEvents()
    }

    func fetchPinnedEvents() {
        pinnedEvents = CoreDataManager.shared.fetchPinnedEvents()
    }
    
    func removePinnedEvent(_ event: CulturalEventModel) {
        CoreDataManager.shared.unpinEvent(event)
        fetchPinnedEvents()
    }
}
