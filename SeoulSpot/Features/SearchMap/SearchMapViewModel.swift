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
    
//    func fetchNearByEvents(near coordinate: CLLocationCoordinate2D,
//                     completion: @escaping ([CulturalEventModel]) -> Void) {
//        let nearbyEvents = allEvents.filter {
//            // ??????? API 에서 내려오는 값이 lat, lot 반대로 되어 있는거 같음
////            guard let lat = $0.lat, let lot = $0.lot else { return false }
//            guard let lat = $0.lot, let lot = $0.lat else { return false }
//            let eventLocation = CLLocation(latitude: lat, longitude: lot)
//            let userLocation = CLLocation(latitude: coordinate.latitude,
//                                          longitude: coordinate.longitude)
//            return eventLocation.distance(from: userLocation) < 1000 // 1km 이내 필터링
//        }
//        completion(nearbyEvents)
//    }
}
