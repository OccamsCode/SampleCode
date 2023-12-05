//
//  SideBarContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
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
            return newsCategory.text
        }
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

struct SideBarContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach([MenuItem.search, MenuItem.saved]) {
                    navigationLinkForMenuItem($0)
                }

                Section("Categories") {
                    ForEach(MenuItem.newsCategoryItems) {
                        navigationLinkForMenuItem($0)
                    }
                }
                .navigationTitle("Occam News")
            }
            .listStyle(.sidebar)
        }
    }

    private func navigationLinkForMenuItem(_ item: MenuItem) -> some View {
        NavigationLink(destination: viewForMenuItem(item: item)) {
            Label(item.text, systemImage: item.systemImage)
        }
    }

    @ViewBuilder
    private func viewForMenuItem( item: MenuItem) -> some View {
        switch item {
        case .search:
            Color.red
        case .saved:
            Color.blue
        case .category(let newsCategory):
            ZStack {
                Color.green
                Text(newsCategory.text)
            }
        }
    }
}

struct SideBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarContentView()
    }
}
