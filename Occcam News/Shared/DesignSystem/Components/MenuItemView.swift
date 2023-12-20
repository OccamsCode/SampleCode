//
//  MenuItemView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 20/12/2023.
//

import SwiftUI

extension MenuItem {
    struct ListView<Navigation: View>: View {
        @Binding var selection: MenuItem.ID?
        let navigation: (MenuItem) -> Navigation

        var body: some View {
            List(selection: $selection) {
                ForEach([MenuItem.search, .saved]) {
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
    }

    struct ListRowView: View {
        let menuItem: MenuItem
        @Binding var selection: MenuItem.ID?

        var isSelected: Bool {
            return menuItem.id == selection
        }

        var body: some View {
            Button {
                selection = menuItem.id
            } label: {
                Label(menuItem.text, systemImage: menuItem.systemImage)
            }
            .foregroundColor(isSelected ? .white : nil)
            .listRowBackground((isSelected ? Color.accentColor : Color.clear).mask(RoundedRectangle(cornerRadius: 8)))
        }
    }
}

extension MenuItem {
    struct NavigationLinkView<Destination: View, Content: View>: View {
        @Binding var selection: MenuItem.ID?
        let destination: (MenuItem) -> Destination
        let content: () -> Content

        var body: some View {
            if let menuItem = MenuItem(selection) {
                NavigationLink(
                    destination: destination(menuItem),
                    tag: menuItem.id,
                    selection: $selection) {
                        content()
                    }
            }
        }
    }
}
