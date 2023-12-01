//
//  SearchHistoryListView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/11/2023.
//

import SwiftUI

struct SearchHistoryListView: View {

    enum Action {
        case onClearHistory
        case onSelectItem(String)
        case onRemoveItem(String)
    }

    @Binding var items: [String]
    let action: (SearchHistoryListView.Action) -> Void

    var body: some View {
        List {
            HStack {
                Text("Recent Searches")
                Spacer()
                Button("Clear") {
                    action(.onClearHistory)
                }
            }
            .listRowSeparator(.hidden)

            ForEach(items, id: \.self) { history in
                Button(history) {
                    action(.onSelectItem(history))
                }
                .swipeActions {
                    Button(role: .destructive,
                           action: { action(.onRemoveItem(history)) },
                           label: { Label("Delete", systemImage: "trash") })
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(items: .constant(["Item 1", "Item 2", "Item 3"])) { _ in }
    }
}
