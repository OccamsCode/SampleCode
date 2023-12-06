//
//  NewsCategory.swift
//  Occcam News
//
//  Created by Brian Munjoma on 17/11/2023.
//

enum NewsCategory: String, CaseIterable {
    case general
    case world
    case nation
    case business
    case technology
    case entertainment
    case sports
    case science
    case health

    var text: String {
        switch self {
        case .general: return "Top Headlines"
        default:
            return rawValue.capitalized
        }
    }
}

extension NewsCategory: Identifiable {
    var id: String {
        return rawValue
    }
}

extension NewsCategory {
    var systemImage: String {
        switch self {
        case .general:
            return "newspaper"
        case .world:
            return "globe.europe.africa"
        case .nation:
            return "map"
        case .business:
            return "building.2"
        case .technology:
            return "desktopcomputer"
        case .entertainment:
            return "tv"
        case .sports:
            return "sportscourt"
        case .science:
            return "wave.3.right"
        case .health:
            return "cross"
        }
    }
}
