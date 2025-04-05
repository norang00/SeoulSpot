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
   
    // Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SeoulSpot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // Core Data Saving support
    func saveContext(completionHandler: (() -> Void)? = nil) {
        if context.hasChanges {
            do {
                try context.save()
                completionHandler?()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - CulturalEvent CRUD

extension CoreDataManager {
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
        
        saveContext {
            AppDataTracker.shared.updateLastFetchedDate()
            print("이벤트 \(events.count)건 저장 완료")
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
    
    func fetchEvents(predicate: NSPredicate? = nil,
                     sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "startDate", ascending: true)]) -> [CulturalEventModel] {
        
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request).compactMap { $0.toModel() }
        } catch {
            print("fetchEvents 실패:", error)
            return []
        }
    }
    
    func fetchEvents(with filters: [FilterOption]) -> [CulturalEventModel] {
        let predicates = filters.map { $0.predicate }
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return fetchEvents(predicate: compound)
    }
    
    func deleteAllEvents() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CulturalEventEntity.fetchRequest()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CulturalEventEntity")
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
}

// MARK: - PinEvent CRUD

extension CoreDataManager {
    
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
        request.predicate = NSPredicate(format: "uniqueKey == %@", "\(event.title ?? "")-\(event.date ?? "")")

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
        pinned.uniqueKey = "\(event.title ?? "")-\(event.date ?? "")"

        saveContext()
    }
    
    func unpinEvent(_ event: CulturalEventModel) {
        let fetchRequest: NSFetchRequest<PinnedEventEntity> = PinnedEventEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueKey == %@", "\(event.title ?? "")-\(event.date ?? "")")

        do {
            let result = try context.fetch(fetchRequest)
            result.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("핀 삭제 실패: \(error)")
        }
    }
    
}

// MARK: - FilterOption

enum FilterOption {
    case codeName(String)
    case dateRange(Date, Date)
    case guName(String)
    case isFree
    case place(String)
    case target(String)
    
    var predicate: NSPredicate {
        switch self {
        case .codeName(let name):
            return NSPredicate(format: "codeName CONTAINS[c] %@", name)
        case .dateRange(let from, let to):
            return NSPredicate(format: "startDate >= %@ AND startDate <= %@", from as NSDate, to as NSDate)
        case .guName(let gu):
            return NSPredicate(format: "guName CONTAINS[c] %@", gu)
        case .isFree:
            return NSPredicate(format: "isFree CONTAINS[c] %@", "무료")
        case .place(let keyword):
            return NSPredicate(format: "place CONTAINS[c] %@", keyword)
        case .target(let keyword):
            return NSPredicate(format: "useTarget CONTAINS[c] %@", keyword)
        }
    }
}
