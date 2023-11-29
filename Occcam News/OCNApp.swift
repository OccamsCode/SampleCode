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
    private let respository = NewsRepository()

    var body: some Scene {
        WindowGroup {
            TabView {
                newsTab
                bookmarkTab
            }
            .environmentObject(bookmarks)
        }
    }
}

private extension TestApp {
    private var newsTab: some View {
        return NewsTabView(observable: topheadlineObservable)
            .tabItem { Label("News", systemImage: "newspaper") }
    }

    private var bookmarkTab: some View {
        return BookmarkTabView()
            .tabItem {  Label("Saved", systemImage: "bookmark") }
    }
}

private extension TestApp {
    private var topheadlineObservable: ArticleListViewObservable {
        ArticleListViewObservable(repository: respository)
    }
    
}
