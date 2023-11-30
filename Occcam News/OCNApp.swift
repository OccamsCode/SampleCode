//
//  OCNApp.swift
//  Occcam News
//
//  Created by Brian Munjoma on 13/11/2023.
//

import SwiftUI

@main
struct OCNApp: App {

    @StateObject var bookmarks = ArticleBookmarkObservable()
    private let respository = NewsRepository()

    var body: some Scene {
        WindowGroup {
            TabView {
                newsTab
                searchTab
                bookmarkTab
            }
            .environmentObject(bookmarks)
        }
    }
}

private extension OCNApp {
    private var newsTab: some View {
        return NewsTabView(observable: topheadlineObservable)
            .tabItem { Label("News", systemImage: "newspaper") }
    }

    private var searchTab: some View {
        return SearchTabView()
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
    }

    private var bookmarkTab: some View {
        return BookmarkTabView()
            .tabItem {  Label("Saved", systemImage: "bookmark") }
    }
}

private extension OCNApp {
    private var topheadlineObservable: ArticleListViewObservable {
        ArticleListViewObservable(repository: respository)
    }

    private var searchTabView: some View {
        return SearchTabView()
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
    }
}
