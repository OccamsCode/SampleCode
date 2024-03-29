//
//  TabContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
//

import SwiftUI

struct TabContentView<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        TabView {
            content
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView {
            ForEach([Color.red, .green, .blue], id: \.self) { color in
                color
                    .tabItem { Label(String(describing: color), systemImage: "") }
            }
        }
    }
}
