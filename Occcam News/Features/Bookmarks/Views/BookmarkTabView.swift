//
//  BookmarkTabView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 27/11/2023.
//

import SwiftUI

struct BookmarkTabView: View {

    @EnvironmentObject var observable: ArticleBookmarkObservable
    @State var searchText: String = ""
    var body: some View {
        let filteredArticles = articles
        NavigationView {
            ArticleListView(articles: filteredArticles)
                .overlay(overlayView(isEmpty: filteredArticles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searchText)
    }

    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            ContentErrorView(title: "No saved articles",
                             message: "You have not bookmarked any articles")
        }
    }

    private var articles: [Article] {
        if searchText.isEmpty {
            return observable.bookmarks
        } else {
            let searchTerm = searchText.lowercased()
            return observable.bookmarks
                .filter {
                    $0.title.localizedCaseInsensitiveContains(searchTerm) ||
                    $0.description.localizedCaseInsensitiveContains(searchTerm)
                }
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(ArticleBookmarkObservable())
    }
}
