//
//  BookmarkTabView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 27/11/2023.
//

import SwiftUI

struct BookmarkTabView: View {

    @EnvironmentObject var observable: ArticleBookmarkObservable

    var body: some View {
        NavigationView {
            ArticleListView(articles: observable.bookmarks)
                .overlay(overlayView(isEmpty: observable.bookmarks.isEmpty))
                .navigationTitle("Saved")
        }
    }

    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            ContentErrorView(title: "No saved articles",
                             message: "You have not bookmarked any articles")
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(ArticleBookmarkObservable())
    }
}
