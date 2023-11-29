//
//  OCNApp.swift
//  Occcam News
//
//  Created by Brian Munjoma on 13/11/2023.
//

import SwiftUI

@main
struct TestApp: App {

    @StateObject var bookmarks = ArticleBookmarkObservable()

    var body: some Scene {
        WindowGroup {
            TabView {
                NewsTabView()
                    .tabItem { Label("News", systemImage: "newspaper") }

                BookmarkTabView()
                    .tabItem {  Label("Saved", systemImage: "bookmark") }
            }
            .environmentObject(bookmarks)
        }
    }
}
