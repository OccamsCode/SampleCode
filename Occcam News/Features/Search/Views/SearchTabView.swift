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
        NavigationView {
            AsyncContentView(source: observable) { articles in
                switch articles.isEmpty {
                case true:
                    ContentErrorView(title: "No results found for '\(observable.searchTerm)'",
                                     message: "Please try again using a different key word")
                case false:
                    ArticleListView(articles: articles)
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $observable.searchTerm) { suggestionsView }
        .onSubmit(of: .search, observable.load)
    }

    @ViewBuilder
    private var suggestionsView: some View {
        VStack {
            ForEach(["SwiftUI", "Lite coin", "MacBook Pro M3"], id: \.self) { text in
                Button {
                    observable.searchTerm = text
                } label: {
                    Text(text)
                }
            }
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
