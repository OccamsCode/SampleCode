//
//  NewsTabView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 21/11/2023.
//

import SwiftUI
import Poppify

struct NewsTabView: View {

    @StateObject var observable: ArticleListViewObservable
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        AsyncContentView(source: observable, loadingView: LoadingView()) {
            Color.clear.onAppear { observable.load() }
        } content: { articles in
            ArticleListView(articles: articles)
                .navigationTitle(observable.selectedCategory.text)
                .navigationBarItems(trailing: navigationBarItems)
                .onChange(of: observable.selectedCategory) { _ in
                    observable.load()
                }
        }
    }

    @ViewBuilder
    private var navigationBarItems: some View {
        switch horizontalSizeClass {
        case .regular:
            Button(action: observable.load) {
                Image(systemName: "arrow.clockwise")
            }
        default:
            menu
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
            ArticleListView(articles: Array(repeating: .preview, count: 6))
                .redacted(reason: .placeholder)
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {

    struct PreviewRepo: TopHeadlinesRepository {
        func fetchTopHeadlines(inCategory: NewsCategory) async throws -> Result<[Article], RequestError> {
            return .failure(.invalidData)
        }
    }

    static var previews: some View {
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .loading))
        .environmentObject(ArticleBookmarkObservable(PreviewStore()))
            .previewDisplayName("Loading State")
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .success([.preview])))
            .previewDisplayName("Success State")
            .environmentObject(ArticleBookmarkObservable(PreviewStore()))
        NewsTabView(observable: ArticleListViewObservable(repository: PreviewRepo(),
                                                          phase: .failure(RequestError.invalidData)))
            .previewDisplayName("Failed State")
            .environmentObject(ArticleBookmarkObservable(PreviewStore()))
    }
}
