//
//  ArticleBookmarkObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/11/2023.
//

import SwiftUI

@MainActor
class ArticleBookmarkObservable: ObservableObject {
    @Published private(set) var bookmarks: [Article] = []

    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }

    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else { return }
        bookmarks.insert(article, at: 0)
    }

    @discardableResult
    func removeBookmark(for article: Article) -> Article? {
        guard let index = bookmarks.firstIndex(where: { article.id == $0.id }) else { return nil }
        return bookmarks.remove(at: index)
    }
}
