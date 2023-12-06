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
            SideBarContentView {
                switch $0 {
                case .search:
                    searchView
                case .saved:
                    bookmarkView
                case .category(let newsCategory):
                    anotherNews(newsCategory)
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
    private var topHeadlinesView: some View {
        return NewsTabView(observable: topheadlineObservable)
    }

    private var searchView: some View {
        return SearchTabView(observable: searchObservable)
    }

    private var bookmarkView: some View {
        return BookmarkTabView()
    }
}

private extension RootContentView {
    private var headlinesTab: some View {
        return NavigationView {
            topHeadlinesView
        }
        .tabItem { Label("News", systemImage: "newspaper") }
    }

    private var searchTab: some View {
        return NavigationView {
            searchView
        }
        .tabItem { Label("Search", systemImage: "magnifyingglass") }
    }

    private func anotherNews(_ cat: NewsCategory) -> some View {
        let obj = topheadlineObservable
        obj.selectedCategory = cat
        return NewsTabView(observable: obj)
    }

    private var bookmarkTab: some View {
        return NavigationView {
            bookmarkView
        }
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
