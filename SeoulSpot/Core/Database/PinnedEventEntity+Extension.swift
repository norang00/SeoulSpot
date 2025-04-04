//
//  PinnedEventEntity+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/4/25.
//

import Foundation

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
            lot: self.lot,
            lat: self.lat,
            isFree: self.isFree,
            homepage: self.homepage
        )
    }
}


