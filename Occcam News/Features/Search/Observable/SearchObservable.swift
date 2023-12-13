//
//  SearchObservable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/11/2023.
//

import Foundation

@MainActor
class SearchObservable: ObservableObject, LoadableObject {

    private let repository: SearchNewsRepository
    private let dataStore = PlistStore<[String]>("SearchHistory")
    @Published private(set) var phase: LoadingState<[Article]>
    @Published var searchTerm: String
    @Published var searchHistoryTerms: [String]

    private let maximumSearchHistoryLimit: Int

    internal init(repository: SearchNewsRepository,
                  phase: LoadingState<[Article]> = .idle,
                  searchTerm: String = "",
                  searchHistoryItems: [String] = [],
                  maximumSearchHistoryLimit: Int = 10) {
        self.repository = repository
        self.phase = phase
        self.searchTerm = searchTerm
        self.searchHistoryTerms = searchHistoryItems
        self.maximumSearchHistoryLimit = maximumSearchHistoryLimit
        if searchHistoryItems.isEmpty { loadSearchHistory() }
    }

    func searchArticles() async {

        if Task.isCancelled { return }
        let searchQuery = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchQuery.isEmpty { return }
        phase = .loading
        do {
            let result = try await repository.search(for: searchQuery)
            if Task.isCancelled { return }
            switch result {
            case .success(let success):
                phase = .success(success)
            case .failure(let failure):
                phase = .failure(failure)
            }
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }

    nonisolated func load() {
        Task {
            await searchArticles()
        }
    }

    func resetToIdle() { phase = .idle }

    func addHistory(_ newSearchTerm: String) {
        if let index = searchHistoryTerms.firstIndex(where: {
            newSearchTerm.caseInsensitiveCompare($0) == .orderedSame
        }) {
            searchHistoryTerms.remove(at: index)
        } else if searchHistoryTerms.count == maximumSearchHistoryLimit {
            searchHistoryTerms.removeLast()
        }

        searchHistoryTerms.insert(newSearchTerm, at: searchHistoryTerms.startIndex)
        persistSearchHistory()
    }

    func removeHistory(_ newSearchTerm: String) {
        searchHistoryTerms.removeAll {
            newSearchTerm.caseInsensitiveCompare($0) == .orderedSame
        }
        persistSearchHistory()
    }

    func clearAllHistory() {
        searchHistoryTerms.removeAll()
        persistSearchHistory()
    }

    private func loadSearchHistory() {
        Task {
            await self.searchHistoryTerms = dataStore.load() ?? []
        }
    }

    private func persistSearchHistory() {
        Task {
            await dataStore.save(searchHistoryTerms)
        }
    }
}
