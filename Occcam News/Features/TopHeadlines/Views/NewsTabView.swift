//
//  NewsTabView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 21/11/2023.
//

import SwiftUI

struct NewsTabView: View {

    @StateObject var observable = ArticleListViewObservable(repository: NewsRepository())
    var body: some View {
        NavigationView {
            switch observable.phase {
            case .success(let articles):
                ArticleListView(articles: articles)
                    .navigationTitle(observable.selectedCategory.text)
            case .loading:
                Color.blue
            case .idle:
                Color.clear
                    .onAppear {
                        Task {
                            await observable.fetchArticles()
                        }
                    }
            case .failure(let error):
                ContentErrorView(title: "Something went wrong",
                          message: error.localizedDescription,
                          actionTitle: "Refresh",
                          callback: { Task { await observable.fetchArticles()}})
            }
        }
    }
}

import Poppify
struct NewsTabView_Previews: PreviewProvider {

    struct PreviewRepo: TopHeadlinesRepository {
        func fetchTopHeadlines(inCategory: NewsCategory) async throws -> Result<[Article], RequestError> {
            return .failure(.invalidData)
        }
    }

    static var previews: some View {
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .loading))
            .previewDisplayName("Loading State")
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .success([.preview])))
            .previewDisplayName("Success State")
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .failure(RequestError.invalidData)))
            .previewDisplayName("Failed State")
    }
}
