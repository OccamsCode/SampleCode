//
//  SearchNewsViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import Foundation

class SearchNewsViewModel {
    
    private let client: APIClient
    private var totalExpectedResults: Int
    private var currentPage: Int
    private var articles: [Article]
    
    weak var coordinator: SearchFlowCoordinator?
    
    init(client: APIClient, articles: [Article] = []) {
        self.client = client
        self.articles = articles
        self.totalExpectedResults = 0
        self.currentPage = 0
    }
    
}

extension SearchNewsViewModel {
    
    var numberOfSections: Int {
        articles.isEmpty ? 0 : articles.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return articles.count
        
    }
    
    func article(at indexPath: IndexPath) -> Article? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[indexPath.row]
        
    }
    
}
