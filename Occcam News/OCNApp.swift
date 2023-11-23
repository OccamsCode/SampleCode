//
//  OCNApp.swift
//  Occcam News
//
//  Created by Brian Munjoma on 13/11/2023.
//

import SwiftUI

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
        }
    }
}
