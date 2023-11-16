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

    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article, action: {
                    switch $0 {
                    case .onShare: articleAction = .share(article)
                    case .onBookmark: print("Bookmark")
                    }
                })
                    .onTapGesture {
                        articleAction = .selected(article)
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $articleAction) { action in

            switch action {
            case .selected(let article):
            if let url = article.url {
                SafariView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                EmptyView()
            }
            case .share(let article):
                if let url = article.url {
                    ShareView(activityItems: [url])
                        .edgesIgnoringSafeArea(.bottom)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles: [Article.preview, Article.preview])
    }
}
