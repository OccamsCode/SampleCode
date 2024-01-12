//
//  SideBarContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
//

import SwiftUI

struct SideBarContentView<DetailContent: View>: View {
    @Binding var selectedMenuItem: MenuItem.ID?
    private var selection: Binding<MenuItem.ID?> {
        Binding {
            selectedMenuItem ?? MenuItem.category(.general).id
        } set: { newValue in
            if let newValue = newValue {
                selectedMenuItem = newValue
            }
        }
    }

    @ViewBuilder let detailContent: (MenuItem) -> DetailContent

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationSplitView {
                MenuItem.ListView(selection: selection) { menuItem in
                        Label(menuItem.text, systemImage: menuItem.systemImage)
                    }
            } detail: {
                detailContent(MenuItem(selection.wrappedValue) ?? .category(.general))
            }
        } else {
            NavigationView {
                ZStack {
                    MenuItem.NavigationLinkView(selection: selection, destination: detailContent) {
                        EmptyView()
                    }
                    MenuItem.ListView(selection: selection) {
                        MenuItem.ListRowView(menuItem: $0, selection: selection)
                    }
                }
            }
        }
    }
}

struct SideBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarContentView(selectedMenuItem: .constant(nil)) { item in
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
