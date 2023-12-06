//
//  ArticleListView.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import SwiftUI

struct ArticleListView: View {

    enum Action: Identifiable {
        case selected(Article)
        case share(Article)

        var id: String {
            switch self {
            case .selected(let article): return "selected:\(article.id)"
            case .share(let article): return "share:\(article.id)"
            }
        }
    }

    let articles: [Article]
    @State private var articleAction: ArticleListView.Action?
    @EnvironmentObject var bookmarks: ArticleBookmarkObservable

    var body: some View {
        AdaptiveLayoutContentView {
            ForEach(articles) { article in
                ArticleRowView(article: article,
                               bookmarkIcon: {
                    Image(systemName: bookmarks.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                },
                               action: {
                    switch $0 {
                    case .onShare: articleAction = .share(article)
                    case .onBookmark: toogleBookmark(for: article)
                    }
                })
            }
        }
        .sheet(item: $articleAction) { action in

            switch action {
            case .selected(let article):
                SafariView(url: article.url)
                    .edgesIgnoringSafeArea(.bottom)
            case .share(let article):
                ShareView(activityItems: [article.url])
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    private func toogleBookmark(for article: Article) {
        if bookmarks.isBookmarked(for: article) {
            bookmarks.removeBookmark(for: article)
        } else {
            bookmarks.addBookmark(for: article)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles: [Article.preview, Article.preview])
            .environmentObject(ArticleBookmarkObservable())
    }
}
