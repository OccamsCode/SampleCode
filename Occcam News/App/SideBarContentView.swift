//
//  SideBarContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
//

import SwiftUI

struct SideBarContentView<Content: View>: View {
    private let content: (MenuItem) -> Content

    @AppStorage("menu_item_selection") var selectedMenuItem: MenuItem.ID?
    private var selection: Binding<MenuItem.ID?> {
        Binding {
            selectedMenuItem ?? MenuItem.category(.general).id
        } set: { newValue in
            if let newValue = newValue {
                selectedMenuItem = newValue
            }
        }

    }

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
        List(selection: selection) {
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
        NavigationLink(destination: viewForMenuItem(item: item), tag: item.id, selection: selection) {
            Label(item.text, systemImage: item.systemImage)
        }
    }

    @ViewBuilder
    private func viewForMenuItem(item: MenuItem) -> some View {
        content(item)
    }

    @ViewBuilder
    private var navigationLink: some View {
        if let menuItem = MenuItem(selection.wrappedValue) {
            NavigationLink(
                destination: viewForMenuItem(item: menuItem),
                tag: menuItem.id,
                selection: selection) {
                    EmptyView()
            }
        }
    }

    @ViewBuilder
    private func listRowForMenuItem(_ item: MenuItem) -> some View {
        let isSelected = item.id == selection.wrappedValue
        Button {
            self.selection.wrappedValue = item.id
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
