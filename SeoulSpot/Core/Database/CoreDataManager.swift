//
//  CoreDataManager.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/3/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()

    private init() { }

    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData 저장 완료")
            } catch {
                print("CoreData 저장 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - CulturalEvent
    
    // DTO → CoreDataEntity 매핑 및 저장
    func saveEventBatch(_ events: [CulturalEvent]) {
        events.forEach { event in
            let entity = CulturalEventEntity(context: context)
            entity.codeName = event.codeName
            entity.guName = event.guName
            entity.title = event.title
            entity.date = event.date
            entity.place = event.place
            entity.orgName = event.orgName
            entity.useTarget = event.useTarget
            entity.useFee = event.useFee
            entity.player = event.player
            entity.program = event.program
            entity.etcDesc = event.etcDesc
            entity.orgLink = event.orgLink
            entity.mainImage = event.mainImage
            entity.rgstDate = event.rgstDate
            entity.ticket = event.ticket
            entity.startDate = event.startDate?.toDate()
            entity.endDate = event.endDate?.toDate()
            entity.themeCode = event.themeCode
            entity.lot = Double(event.lot ?? "") ?? 0
            entity.lat = Double(event.lat ?? "") ?? 0
            entity.isFree = event.isFree
            entity.homepage = event.homepage
            entity.uniqueKey = "\(event.title)-\(event.date)"
        }
        
        do {
            try context.save()
            AppDataTracker.shared.updateLastFetchedDate()
            print("이벤트 \(events.count)건 저장 완료")
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    // DTO → CoreDataEntity 매핑 및 저장
    func saveEvent(_ event: CulturalEvent) {
        let entity = CulturalEventEntity(context: context)
        entity.codeName = event.codeName
        entity.guName = event.guName
        entity.title = event.title
        entity.date = event.date
        entity.place = event.place
        entity.orgName = event.orgName
        entity.useTarget = event.useTarget
        entity.useFee = event.useFee
        entity.player = event.player
        entity.program = event.program
        entity.etcDesc = event.etcDesc
        entity.orgLink = event.orgLink
        entity.mainImage = event.mainImage
        entity.rgstDate = event.rgstDate
        entity.ticket = event.ticket
        entity.startDate = event.startDate?.toDate()
        entity.endDate = event.endDate?.toDate()
        entity.themeCode = event.themeCode
        entity.lot = Double(event.lot ?? "") ?? 0
        entity.lat = Double(event.lat ?? "") ?? 0
        entity.isFree = event.isFree
        entity.homepage = event.homepage
        entity.uniqueKey = "\(event.title)-\(event.date)"
        
        saveContext()
    }

    func fetchAllEvents() -> [CulturalEventModel] {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            let events = entities.compactMap { $0.toModel() }
            return events
        } catch {
            return []
        }
    }
    
    func fetchEvents(startingFrom start: Date, to end: Date) -> [CulturalEventModel] {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "startDate >= %@ AND startDate <= %@", start as NSDate, end as NSDate)

        print(#function, start, end)
        dump(request.predicate)
        
        do {
            let entities = try context.fetch(request)
            let events = entities.compactMap { $0.toModel() }
            print(#function, "do", events)
            return events
        } catch {
            print("fetchMainEvents 실패: \(error)")
            return []
        }
    }
    
    func fetchEvents(codeName: String) -> [CulturalEventModel] {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "codeName == %@", codeName)

        do {
            let entities = try context.fetch(request)
            let events = entities.compactMap { $0.toModel() }
            print(events.prefix(5))
            return events
        } catch {
            print("fetchEvents(codeName:) 실패: \(error)")
            return []
        }
    }
    
    func deleteAllEvents() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CulturalEventEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("CoreDataManager - DeleteAllEvents Failed")
        }
    }
    
    func deleteEvent(_ event: CulturalEventModel) {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", event.title ?? "")

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
            print("Deleted from CoreData")
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    // MARK: - Pin
    
    func fetchPinnedEvents() -> [CulturalEventModel] {
        let request: NSFetchRequest<PinnedEventEntity> = PinnedEventEntity.fetchRequest()

        do {
            let pinnedEntities = try context.fetch(request)
            let pinnedEvents = pinnedEntities.compactMap { $0.toModel() }
            return pinnedEvents
        } catch {
            return []
        }
    }
    
    func isEventPinned(_ event: CulturalEventModel) -> Bool {
        let request: NSFetchRequest<PinnedEventEntity> = PinnedEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uniqueKey == %@", "\(event.title)-\(event.date)")

        do {
            return try !context.fetch(request).isEmpty
        } catch {
            return false
        }
    }
    
    // CulturalEventModel → PineedEventEntity 매핑 및 저장
    func pinEvent(_ event: CulturalEventModel) {
        guard !isEventPinned(event) else { return }
        let pinned = PinnedEventEntity(context: context)
        pinned.codeName = event.codeName
        pinned.guName = event.guName
        pinned.title = event.title
        pinned.date = event.date
        pinned.place = event.place
        pinned.orgName = event.orgName
        pinned.useTarget = event.useTarget
        pinned.useFee = event.useFee
        pinned.player = event.player
        pinned.program = event.program
        pinned.etcDesc = event.etcDesc
        pinned.orgLink = event.orgLink
        pinned.mainImage = event.mainImage
        pinned.rgstDate = event.rgstDate
        pinned.ticket = event.ticket
        pinned.startDate = event.startDate
        pinned.endDate = event.endDate
        pinned.themeCode = event.themeCode
        pinned.lot = event.lot ?? 0
        pinned.lat = event.lat ?? 0
        pinned.isFree = event.isFree
        pinned.homepage = event.homepage
        pinned.uniqueKey = "\(event.title)-\(event.date)"

        saveContext()
    }
    
    func unpinEvent(_ event: CulturalEventModel) {
        let fetchRequest: NSFetchRequest<PinnedEventEntity> = PinnedEventEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueKey == %@", "\(event.title)-\(event.date)")

        do {
            let result = try context.fetch(fetchRequest)
            result.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("핀 삭제 실패: \(error)")
        }
    }
    
}
