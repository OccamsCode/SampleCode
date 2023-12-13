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

struct SideBarContentView<Content: View>: View {
    private let content: (MenuItem) -> Content
    @State var selectedMenuItem: MenuItem.ID? = MenuItem.category(.general).id

    init(@ViewBuilder content: @escaping (MenuItem) -> Content) {
        self.content = content
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationSplitView {
                listView {
                    navigationLinkForMenuItem($0)
                }
            } detail: {
                viewForMenuItem(item: .category(.general))
            }
        } else {
            NavigationView {
                ZStack {
                    navigationLink
                    listView {
                        listRowForMenuItem($0)
                    }
                }
            }
        }

    }

    @ViewBuilder
    private func listView(@ViewBuilder _ navigation: @escaping (MenuItem) -> some View) -> some View {
        List(selection: $selectedMenuItem) {
            ForEach([MenuItem.search, MenuItem.saved]) {
                navigation($0)
            }

            Section {
                ForEach(MenuItem.newsCategoryItems) {
                    navigation($0)
                }
            } header: {
                Text("Categories")
            }
            .navigationTitle("Occam News")
        }
        .listStyle(.sidebar)
    }

    private func navigationLinkForMenuItem(_ item: MenuItem) -> some View {
        NavigationLink(destination: viewForMenuItem(item: item), tag: item.id, selection: $selectedMenuItem) {
            Label(item.text, systemImage: item.systemImage)
        }
    }

    @ViewBuilder
    private func viewForMenuItem(item: MenuItem) -> some View {
        content(item)
    }

    @ViewBuilder
    private var navigationLink: some View {
        if let menuItem = MenuItem(selectedMenuItem) {
            NavigationLink(
                destination: viewForMenuItem(item: menuItem),
                tag: menuItem.id,
                selection: $selectedMenuItem) {
                    EmptyView()
            }
        }
    }

    @ViewBuilder
    private func listRowForMenuItem(_ item: MenuItem) -> some View {
        let isSelected = item.id == selectedMenuItem
        Button {
            self.selectedMenuItem = item.id
        } label: {
            Label(item.text, systemImage: item.systemImage)
        }
        .foregroundColor(isSelected ? .white : nil)
        .listRowBackground((isSelected ? Color.accentColor : Color.clear).mask(RoundedRectangle(cornerRadius: 8)))
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
