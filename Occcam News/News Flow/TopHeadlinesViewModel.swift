//
//  TopHeadlinesViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

class TopHeadlinesViewModel {
    
    private var items: [Int]
    
    private let client: APIClient
    
    init(client: APIClient, model: [Int]) {
        self.items = model
        self.client = client
    }
    
    var numberOfSections: Int {
        items.isEmpty ? 0 : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return items.count
        
    }
    
    func item(at indexPath: IndexPath) -> Int? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return items[indexPath.row]
        
    }
    
    func update(completion: @escaping () -> Void) {
        
        let topHeadlines = NewsAPI.topHeadlines
        
        client.fetch(from: topHeadlines, into: TopHeadlines.self) { (result) in
            
            switch result {
            case .success(let topHeadlines):
                print(topHeadlines.status)
                self.items = Array(0...topHeadlines.totalResults)
            case .failure(let error):
                print(error)
            }
            
            completion()
            
        }
    }
    
}
