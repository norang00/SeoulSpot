//
//  AppDataTracker.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/4/25.
//

import Foundation

final class AppDataTracker {
    
    private let lastUpdatedKey = "lastEventUpdateDate"
    
    static let shared = AppDataTracker()
    
    private init() { }
    
    func shouldRefreshEventData() -> Bool {
        guard let lastDate = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date else {
            return true // UserDefaults 에 해당 키에 관한 값이 없음 -> 처음 실행
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        // 이벤트가 마지막으로 갱신된 것이 오늘이 아닌 경우 -> 갱신 필요
        if !calendar.isDateInToday(lastDate) {
            return true
        }
        
        // 이벤트가 마지막으로 갱신된 것이 오늘이지만, 지금 밤 9시가 넘었고, 갱신 데이터는 밤 9시 전인 경우 -> 갱신 필요
        if let ninePM = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: now),
           now >= ninePM, lastDate < ninePM {
            return true
        }
        
        return false
    }
    
    func updateLastFetchedDate() {
        UserDefaults.standard.set(Date(), forKey: lastUpdatedKey)
    }
    
}
