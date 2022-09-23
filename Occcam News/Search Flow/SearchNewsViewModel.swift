//
//  SearchNewsViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

class SearchNewsViewModel {
    
    private let client: APIClient
    private var totalExpectedResults: Int
    private var currentPage: Int
    private var currentSearchTerm: String?
    private var articles: [Article]
    private var isFetchInProgress: Bool
    private var selectedContextActionIndexPath: IndexPath?
    private(set) var generatedPreview: Previewable!
    
    weak var coordinator: SearchFlowCoordinator?
    
    init(client: APIClient, articles: [Article] = []) {
        self.client = client
        self.articles = articles
        self.totalExpectedResults = 0
        self.currentPage = 1
        self.isFetchInProgress = false
    }
    
    func search(for searchTerm: String, completion: @escaping () -> Void) {
        
        currentPage = 1
        let searching = NewsAPI.search(term: searchTerm, page: currentPage, pageSize: 30)
        currentSearchTerm = searchTerm
        client.fetch(from: searching, into: SearchResult.self) { [unowned self] result in
            
            switch result {
            case .success(let searchResults):
                self.totalExpectedResults = searchResults.totalResults
                self.articles = searchResults.articles.sorted { return $0.published_at > $1.published_at }
            case .failure(let error):
                Log.error(error)
                
            }
            
            completion()
        }
        
    }
    
    func loadMore(completion: @escaping ([IndexPath]?) -> Void) {
        
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        guard let currentSearchTerm = currentSearchTerm else { return completion(.none) }
        currentPage += 1
        let nextPage = NewsAPI.search(term: currentSearchTerm, page: currentPage, pageSize: 30)
        
        client.fetch(from: nextPage, into: SearchResult.self) { [unowned self] result in
            
            self.isFetchInProgress = false
            switch result {
            case .success(let searchResults):
                
                let startIndex = self.articles.count
                self.articles.append(contentsOf: searchResults.articles)
                let endIndex = self.articles.count
                let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                completion(newIndexPaths)
            case .failure(let error):
                Log.error(error)
            }
            
            completion(.none)
            
        }
        
    }
}

extension SearchNewsViewModel {
    
    var numberOfSections: Int {
        articles.isEmpty ? 0 : 1
    }
    
    var expectedTotalResults: Int {
        return totalExpectedResults
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return articles.count
        
    }
    
    func article(at indexPath: IndexPath) -> Article? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[indexPath.row]
        
    }
    
    func heightForCell(at indexPath: IndexPath, given width: CGFloat) -> CGFloat {
        
        //FIXME: Dynamic for dynamic sized fonts
        return 100
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        guard let article = article(at: indexPath) else {
            return
        }
        
        coordinator?.navigate(.toArticle(article))
        
    }
    
    func didSelectContextActionForItem(at indexPath: IndexPath) -> Previewable {
        
        guard let article = article(at: indexPath) else { fatalError() }
        generatedPreview = ViewControllerFactory.preview(for: article)
        return generatedPreview
    }
    
    func willPerformContextAction() {
        
        guard let preview = generatedPreview else {
            return
        }
        coordinator?.navigate(.toPreview(preview))
        
    }
}


