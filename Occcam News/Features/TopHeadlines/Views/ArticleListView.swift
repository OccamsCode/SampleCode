//
//  ArticleListView.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var selectedArticle: Article?

    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) { article in
            if let url = article.url {
                SafariView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                EmptyView()
            }
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles: [Article.preview, Article.preview])
    }
}
