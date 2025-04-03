//
//  Resources.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

enum Resources: CaseIterable {
    case curation
    case searchMap
    case pinned

    var title: String {
        switch self {
        case .curation: return ""
        case .searchMap: return ""
        case .pinned: return ""
        }
    }

    var icon: UIImage? {
        switch self {
        case .curation: return UIImage(systemName: "sparkles")
        case .searchMap: return UIImage(systemName: "mappin.and.ellipse")
        case .pinned: return UIImage(systemName: "pin")
        }
    }
}
