//
//  ArticleBookmarkObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/11/2023.
//

import SwiftUI

@MainActor
class ArticleBookmarkObservable<LocalStore: Store>: ObservableObject where LocalStore.Value == [Article] {
    @Published private(set) var bookmarks: [Article] = []
    private let store: LocalStore

    init(_ store: LocalStore) {
        self.store = store
        Task {
            await bookmarks = store.load() ?? []
        }
    }

    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }

    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else { return }
        bookmarks.insert(article, at: 0)
        persistBookmarks()
    }

    @discardableResult
    func removeBookmark(for article: Article) -> Article? {
        guard let index = bookmarks.firstIndex(where: { article.id == $0.id }) else { return nil }
        let removedArticle = bookmarks.remove(at: index)
        persistBookmarks()
        return removedArticle
    }

    private func persistBookmarks() {
        Task {
            await store.save(bookmarks)
        }
    }
}
