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
            AsyncContentView(source: observable, loadingView: LoadingView()) { articles in
                ArticleListView(articles: articles)
                    .navigationTitle(observable.selectedCategory.text)
                    .navigationBarItems(trailing: menu)
                    .onChange(of: observable.selectedCategory) { _ in
                        observable.load()
                    }
            }
        }
    }

    private var menu: some View {
        Menu {
            Picker("Category", selection: $observable.selectedCategory) {
                ForEach(NewsCategory.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .imageScale(.large)
        }
    }
}

extension NewsTabView {

    struct LoadingView: View {
        var body: some View {
            ArticleListView(articles: [.preview, .preview])
                .redacted(reason: .placeholder)
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
