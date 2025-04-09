//
//  SearchMapViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation
import CoreLocation

final class SearchMapViewModel: BaseViewModel {
    
    private var allEvents: [CulturalEventModel]

    init(allEvents: [CulturalEventModel] = CoreDataManager.shared.fetchEvents()) {
        self.allEvents = allEvents
        super.init()
    }
    
    func fetchAllEvents() -> [CulturalEventModel] {
        return allEvents
    }
    
    func fetchNearByEvents(near coordinate: CLLocationCoordinate2D,
                           completion: @escaping ([CulturalEventModel]) -> Void) {
        let nearbyEvents = allEvents.filter {
            guard let lat = $0.lat, let lot = $0.lot else { return false }
            let eventLocation = CLLocation(latitude: lat,
                                           longitude: lot)
            let cameraLocation = CLLocation(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude)
            return eventLocation.distance(from: cameraLocation) < 10000 // 10km 이내 필터링
        }
        completion(nearbyEvents)
    }
}
