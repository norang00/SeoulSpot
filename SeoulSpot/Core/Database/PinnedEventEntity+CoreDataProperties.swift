//
//  PinnedEventEntity+CoreDataProperties.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/5/25.
//
//

import Foundation
import CoreData


extension PinnedEventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PinnedEventEntity> {
        return NSFetchRequest<PinnedEventEntity>(entityName: "PinnedEventEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var place: String?
    @NSManaged public var codeName: String?
    @NSManaged public var guName: String?
    @NSManaged public var isFree: String?
    @NSManaged public var mainImage: String?
    @NSManaged public var orgName: String?
    @NSManaged public var lat: Double
    @NSManaged public var lot: Double
    @NSManaged public var uniqueKey: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var useTarget: String?
    @NSManaged public var useFee: String?
    @NSManaged public var player: String?
    @NSManaged public var program: String?
    @NSManaged public var etcDesc: String?
    @NSManaged public var orgLink: String?
    @NSManaged public var rgstDate: String?
    @NSManaged public var ticket: String?
    @NSManaged public var themeCode: String?
    @NSManaged public var homepage: String?

}

extension PinnedEventEntity : Identifiable {

}

// MARK: - API 쪽에서 lat lot 반대로 뒤집혀서 오기 때문에 매핑시에 다시 뒤집어 주겠음
extension PinnedEventEntity {
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
            lot: self.lat, // 여기 고의로 반대로 넣음
            lat: self.lot, //
            isFree: self.isFree,
            homepage: self.homepage
        )
    }
}
