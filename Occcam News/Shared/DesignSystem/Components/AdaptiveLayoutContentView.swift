//
//  AdaptiveLayoutContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 06/12/2023.
//

import SwiftUI

struct AdaptiveLayoutContentView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 8) {
                    content()
                }
            }
        default:
            List {
                content()
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}
