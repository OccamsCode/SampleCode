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
    private let repository = NewsRepository()
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            SideBarContentView {
                switch $0 {
                case .search:
                    searchView
                case .saved:
                    bookmarkView
                case .category(let newsCategory):
                    topHeadlinesView(newsCategory)
                }
            }
            .environmentObject(bookmarks)
        default:
            TabContentView {
                headlinesTab
                searchTab
                bookmarkTab
            }
            .environmentObject(bookmarks)
        }
    }
}

private extension RootContentView {
    private func topHeadlinesView(_ category: NewsCategory = .general) -> some View {
        return NewsTabView(observable:
            ArticleListViewObservable(repository: repository, category: category)
        )
    }

    private var searchView: some View {
        return SearchTabView(observable:
            SearchObservable(repository: repository)
        )
    }

    private var bookmarkView: some View {
        return BookmarkTabView()
    }
}

private extension RootContentView {
    private var headlinesTab: some View {
        return NavigationView {
            topHeadlinesView()
        }
        .tabItem { Label("News", systemImage: "newspaper") }
    }

    private var searchTab: some View {
        return NavigationView {
            searchView
        }
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
    }

    private var bookmarkTab: some View {
        return NavigationView {
            bookmarkView
        }
        .tabItem {  Label("Saved", systemImage: "bookmark") }
    }
}
