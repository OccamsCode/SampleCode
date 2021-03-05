//
//  HomeViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation

class HomeViewModel {
    
    private let client: APIClient
    private var articles: [String:[Article]]
    
    init(client: APIClient) {
        self.client = client
        self.articles = [:]
    }
    
    var numberOfSections: Int {
        articles.isEmpty ? 0 : articles.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return 1
        
    }
    
    var sections: [String] {
        return ["Top Headline", "General"]
    }
    
    func items(at indexPath: IndexPath) -> [Article]? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[sections[indexPath.section]]
        
    }
    
    func update(completion: @escaping () -> Void) {
        
        let topHeadlines = NewsAPI.topHeadlines
        
        client.fetch(from: topHeadlines, into: TopHeadlines.self) { [unowned self] result in
            
            switch result {
            case .success(let topHeadlines):
                print("Found \(topHeadlines.totalResults) articles")
                
                let top = Array(topHeadlines.articles.dropFirst())
                
                self.articles["Top Headline"] = top
                self.articles["General"] = topHeadlines.articles
                
            case .failure(let error):
                print(error)
            }
            
            completion()
            
        }
    }
    
}
