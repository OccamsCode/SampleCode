//
//  MenuItem.swift
//  Occcam News
//
//  Created by Brian Munjoma on 19/12/2023.
//

import SwiftUI

enum MenuItem: CaseIterable {
    case search
    case saved
    case category(NewsCategory)

    var text: String {
        switch self {
        case .search:
            return "Search"
        case .saved:
            return "Saved"
        case .category(let newsCategory):
            return newsCategory.text
        }
    }

    var systemImage: String {
        switch self {
        case .search:
            return "magnifyingglass"
        case .saved:
            return "bookmark"
        case .category(let newsCategory):
            return newsCategory.systemImage
        }
    }

    static var allCases: [MenuItem] {
        return [.search, .saved] + newsCategoryItems
    }

    static var newsCategoryItems: [MenuItem] {
        return NewsCategory.allCases.map { .category($0) }
    }
}

extension MenuItem: Identifiable {
    var id: String {
        switch self {
        case .search:
            return "search"
        case .saved:
            return "saved"
        case .category(let newsCategory):
            return newsCategory.id
        }
    }
}

extension MenuItem {
    init?(_ id: MenuItem.ID?) {
        switch id {
        case MenuItem.search.id: self = .search
        case MenuItem.saved.id: self = .saved
        default:
            if let id = id, let category = NewsCategory(rawValue: id.lowercased()) {
                self = .category(category)
            } else {
                return nil
            }
        }
    }
}
