//
//  CulturalEventEntity+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/4/25.
//

import Foundation

extension CulturalEventEntity {
    func toModel() -> CulturalEvent {
        return CulturalEvent(
            codeName: self.codeName ?? "",
            guName: self.guName ?? "",
            title: self.title ?? "",
            date: self.date ?? "",
            place: self.place ?? "",
            orgName: self.orgName ?? "",
            useTarget: self.useTarget ?? "",
            useFee: self.useFee ?? "",
            orgLink: self.orgLink ?? "",
            mainImage: self.mainImage ?? "",
            homepage: self.homepage ?? "",
            isFree: self.isFree ?? "",
            lot: self.lot ?? "",
            lat: self.lat ?? ""
        )
    }
}
