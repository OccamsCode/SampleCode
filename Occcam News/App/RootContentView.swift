//
//  RootContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/12/2023.
//

import SwiftUI

struct RootContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject var bookmarks = ArticleBookmarkObservable(PlistStore("bookmarks"))
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
                        .id(newsCategory.id)
                }
            }
        default:
            TabContentView {
                headlinesTab
                searchTab
                bookmarkTab
            }
        }
    }
}

private extension RootContentView {
    private func topHeadlinesView(_ category: NewsCategory = .general) -> some View {
        return NewsTabView(observable:
            ArticleListViewObservable(repository: repository, category: category)
        )
        .environmentObject(bookmarks)
    }

    private var searchView: some View {
        return SearchTabView(observable:
            SearchObservable(repository: repository)
        )
        .environmentObject(bookmarks)
    }

    private var bookmarkView: some View {
        return BookmarkTabView()
            .environmentObject(bookmarks)
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
