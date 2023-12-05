//
//  RootContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
//

import SwiftUI

struct RootContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject var bookmarks = ArticleBookmarkObservable()
    private let respository = NewsRepository()
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            SideBarContentView()
        default:
            TabContentView {
                newsTab
                searchTab
                bookmarkTab
            }
            .environmentObject(bookmarks)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootContentView()
    }
}

private extension RootContentView {
    private var newsTab: some View {
        return NewsTabView(observable: topheadlineObservable)
            .tabItem { Label("News", systemImage: "newspaper") }
    }

    private var searchTab: some View {
        return SearchTabView(observable: searchObservable)
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
    }

    private var bookmarkTab: some View {
        return BookmarkTabView()
            .tabItem {  Label("Saved", systemImage: "bookmark") }
    }
}

private extension RootContentView {
    private var topheadlineObservable: ArticleListViewObservable {
        ArticleListViewObservable(repository: respository)
    }

    private var searchObservable: SearchObservable {
        SearchObservable(repository: respository)
    }
}
