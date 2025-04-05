//
//  CulturalEventEntity+CoreDataProperties.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/5/25.
//
//

import Foundation
import CoreData


extension CulturalEventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CulturalEventEntity> {
        return NSFetchRequest<CulturalEventEntity>(entityName: "CulturalEventEntity")
    }

    @NSManaged public var codeName: String?
    @NSManaged public var date: String?
    @NSManaged public var guName: String?
    @NSManaged public var homepage: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFree: String?
    @NSManaged public var lat: Double
    @NSManaged public var lot: Double
    @NSManaged public var mainImage: String?
    @NSManaged public var orgLink: String?
    @NSManaged public var orgName: String?
    @NSManaged public var place: String?
    @NSManaged public var title: String?
    @NSManaged public var useFee: String?
    @NSManaged public var useTarget: String?
    @NSManaged public var uniqueKey: String?
    @NSManaged public var player: String?
    @NSManaged public var program: String?
    @NSManaged public var etcDesc: String?
    @NSManaged public var rgstDate: String?
    @NSManaged public var ticket: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var themeCode: String?

}

extension CulturalEventEntity : Identifiable {

}

extension CulturalEventEntity {
    func toModel() -> CulturalEventModel {
        return CulturalEventModel(
            codeName: self.codeName,
            guName: self.guName,
            title: self.title,
            date: self.date,
            place: self.place,
            orgName: self.orgName,
            useTarget: self.useTarget,
            useFee: self.useFee,
            player: self.player,
            program: self.program,
            etcDesc: self.etcDesc,
            orgLink: self.orgLink,
            mainImage: self.mainImage,
            rgstDate: self.rgstDate,
            ticket: self.ticket,
            startDate: self.startDate,
            endDate: self.endDate,
            themeCode: self.themeCode,
            lot: self.lot,
            lat: self.lat,
            isFree: self.isFree,
            homepage: self.homepage
        )
    }
}
