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

struct SideBarContentView<Content: View>: View {
    private let content: (MenuItem) -> Content

    init(@ViewBuilder content: @escaping (MenuItem) -> Content) {
        self.content = content
    }

    var body: some View {
        NavigationView {
            List {
                ForEach([MenuItem.search, MenuItem.saved]) {
                    navigationLinkForMenuItem($0)
                }

                Section {
                    ForEach(MenuItem.newsCategoryItems) {
                        navigationLinkForMenuItem($0)
                    }
                } header: {
                    Text("Categories")
                }
                .navigationTitle("Occam News")
            }
            .listStyle(.sidebar)

            viewForMenuItem(item: .category(.general))
        }
    }

    private func navigationLinkForMenuItem(_ item: MenuItem) -> some View {
        NavigationLink(destination: viewForMenuItem(item: item)) {
            Label(item.text, systemImage: item.systemImage)
        }
    }

    @ViewBuilder
    private func viewForMenuItem(item: MenuItem) -> some View {
        content(item)
    }
}

struct SideBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarContentView { item in
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
}
