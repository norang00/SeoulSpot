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
        entity.orgLink = event.orgLink
        entity.mainImage = event.mainImage
        entity.homepage = event.homepage
        entity.isFree = event.isFree
        entity.lot = event.lot
        entity.lat = event.lat
        
        do {
            try context.save()
            print("Saved to CoreData")
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func isEventPinned(_ event: CulturalEvent) -> Bool {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", event.title)
        do {
            return try context.fetch(request).isEmpty == false
        } catch {
            return false
        }
    }

    func fetchEvents() -> [CulturalEventEntity] {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteEvent(_ event: CulturalEvent) {
        let request: NSFetchRequest<CulturalEventEntity> = CulturalEventEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", event.title)

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
