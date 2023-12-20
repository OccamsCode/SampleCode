//
//  ArticleListViewObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 20/11/2023.
//

import SwiftUI

class ArticleListViewObservable: ObservableObject, LoadableObject {

    private let repository: TopHeadlinesRepository
    @Published private(set) var phase: LoadingState<[Article]>
    @Published var selectedCategory: NewsCategory {
        didSet {
            if oldValue != selectedCategory {
                selectedMenuItem = MenuItem.category(selectedCategory).id
            }
        }
    }
    @AppStorage("menu_item_selection") private var selectedMenuItem: MenuItem.ID?
    internal init(repository: TopHeadlinesRepository,
                  phase: LoadingState<[Article]> = .idle,
                  category: NewsCategory = .general) {
        self.repository = repository
        self.phase = phase
        self.selectedCategory = category
    }

    @MainActor
    func fetchArticles() async {

        if Task.isCancelled { return }
        phase = .loading

        do {
            let result = try await repository.fetchTopHeadlines(inCategory: selectedCategory)
            if Task.isCancelled { return }
            switch result {
            case .success(let articles):
                phase = .success(articles)
            case .failure(let failure):
                phase = .failure(failure)
            }
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }

    func load() {
        Task {
            await fetchArticles()
        }
    }
}
