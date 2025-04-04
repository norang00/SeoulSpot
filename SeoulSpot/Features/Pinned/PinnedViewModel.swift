//
//  PinnedViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation
import Combine

final class PinnedViewModel: BaseViewModel {

    @Published var pinnedEvents: [CulturalEvent] = []

    override init() {
        super.init()
        fetchPinnedEvents()
        
        print("PinnedViewModel", #function, pinnedEvents)
    }

    func fetchPinnedEvents() {
        let entities = CoreDataManager.shared.fetchEvents()
        self.pinnedEvents = entities.compactMap { $0.toModel() }
    }
}
