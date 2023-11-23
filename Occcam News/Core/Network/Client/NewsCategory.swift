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
