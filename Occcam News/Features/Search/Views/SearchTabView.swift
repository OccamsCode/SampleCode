//
//  SearchTabView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/11/2023.
//

import SwiftUI

struct SearchTabView: View {

    @StateObject var observable: SearchObservable

    var body: some View {
        AsyncContentView(source: observable) {
            switch observable.searchHistoryTerms.isEmpty {
            case true:
                ContentErrorView(title: "Type your search query",
                                 message: "")
            case false:
                SearchHistoryListView(items: $observable.searchHistoryTerms,
                                      action: searchHistoryAction)
            }
        } content: { articles in
            switch articles.isEmpty {
            case true:
                ContentErrorView(title: "No results found for '\(observable.searchTerm)'",
                                 message: "Please try again using a different key word")
            case false:
                ArticleListView(articles: articles)
            }
        }
        .navigationTitle("Search")
        .searchable(text: $observable.searchTerm)
        .onChange(of: observable.searchTerm) { newValue in
            if newValue.isEmpty { observable.resetToIdle() }
        }
        .onSubmit(of: .search, search)
    }

    private func search() {
        let searchQuery = observable.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty { observable.addHistory(searchQuery) }
        observable.load()
    }

    private func searchHistoryAction(_ action: SearchHistoryListView.Action) {
        switch action {
        case .onClearHistory:
            observable.clearAllHistory()
        case .onSelectItem(let term):
            observable.searchTerm = term
            search()
        case .onRemoveItem(let term):
            observable.removeHistory(term)
        }
    }
}

import Poppify
struct SearchTabView_Previews: PreviewProvider {

    struct PreviewRepo: SearchNewsRepository {
        func search(for query: String) async throws -> Result<[Article], RequestError> {
            return .failure(.invalidData)
        }
    }

    static var previews: some View {
        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .idle))
            .previewDisplayName("Idle State - No History")

        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .idle, searchHistoryItems: ["One", "Two", "Three"]))
            .previewDisplayName("Idle State w/ History")

        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .loading))
            .previewDisplayName("Loading State")

        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .success([.preview])))
            .previewDisplayName("Success State w/ Results")
            .environmentObject(ArticleBookmarkObservable())

        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .success([]),
                                                   searchTerm: "Tesla"))
            .previewDisplayName("Success State No Results")
            .environmentObject(ArticleBookmarkObservable())

        SearchTabView(observable: SearchObservable(repository: PreviewRepo(),
                                                   phase: .failure(RequestError.invalidRequest)))
            .previewDisplayName("Failure State")
    }
}
