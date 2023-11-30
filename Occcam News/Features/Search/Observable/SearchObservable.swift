//
//  SearchObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/11/2023.
//

import Foundation

class SearchObservable: ObservableObject, LoadableObject {

    private let repository: SearchNewsRepository
    @Published private(set) var phase: LoadingState<[Article]>
    @Published var searchTerm = ""

    internal init(repository: SearchNewsRepository,
                  phase: LoadingState<[Article]> = .idle) {
        self.repository = repository
        self.phase = phase
    }

    @MainActor
    func searchArticles() async {

        let searchQuery = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchQuery.isEmpty { return }
        phase = .loading
        do {
            let result = try await repository.search(for: searchQuery)

            switch result {
            case .success(let success):
                phase = .success(success)
            case .failure(let failure):
                phase = .failure(failure)
            }
        } catch {
            phase = .failure(error)
        }
    }

    func load() {
        Task {
            await searchArticles()
        }
    }
}
