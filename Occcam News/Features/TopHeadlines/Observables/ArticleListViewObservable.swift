//
//  ArticleListViewObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 20/11/2023.
//

import SwiftUI

class ArticleListViewObservable: ObservableObject {

    private let repository: TopHeadlinesRepository
    @Published private(set) var phase: LoadingState<[Article]>
    @Published var selectedCategory: NewsCategory

    internal init(repository: TopHeadlinesRepository,
                  phase: LoadingState<[Article]> = .idle,
                  category: NewsCategory = .general) {
        self.repository = repository
        self.phase = phase
        self.selectedCategory = category
    }

    @MainActor
    func fetchArticles() async {

        phase = .loading

        do {
            let result = try await repository.fetchTopHeadlines(inCategory: selectedCategory)
            switch result {
            case .success(let articles):
                phase = .success(articles)
            case .failure(let failure):
                phase = .failure(failure)
            }
        } catch {
            phase = .failure(error)
        }
    }
}
