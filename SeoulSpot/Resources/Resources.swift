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
        case .curation: return "큐레이션"
        case .searchMap: return "지도에서 보기"
        case .pinned: return "저장한 이벤트"
        }
    }

    var icon: UIImage? {
        switch self {
        case .curation: return UIImage(systemName: "sparkles")
        case .searchMap: return UIImage(systemName: "map")
        case .pinned: return UIImage(systemName: "star.fill")
        }
    }
}
