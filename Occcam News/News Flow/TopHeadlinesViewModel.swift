//
//  TopHeadlinesViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

enum ListItemStyle {
    case feature, subfeature, normal
}

class TopHeadlinesViewModel {
    
    private var articles: [Article]
    
    private let client: APIClient
    
    var cellStyles: [Int: ListItemStyle]
    
    init(client: APIClient, model: [Article]) {
        self.articles = model
        self.client = client
        cellStyles = [:]
    }
    
    var numberOfSections: Int {
        articles.isEmpty ? 0 : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return articles.count
        
    }
    
    func item(at indexPath: IndexPath) -> Article? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[indexPath.row]
        
    }
    
    func styleForItem(at indexPath: IndexPath) -> ListItemStyle {
        
        return .normal
        
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> TopHeadlineCellViewModel? {
        
        guard let item = item(at: indexPath) else { return nil }
        
        switch indexPath.row {
        case 0:
            return TopHeadlineCellViewModel(item, cellType: .featured)
        default:
            return TopHeadlineCellViewModel(item, cellType: .subfeature)
        }

    }
    
//    func sizeForItem(at indexPath: IndexPath, given width: Float) -> (Float, Float) {
//
//    }
    
    func update(completion: @escaping () -> Void) {
        
        let topHeadlines = NewsAPI.topHeadlines
        
        client.fetch(from: topHeadlines, into: TopHeadlines.self) { (result) in
            
            switch result {
            case .success(let topHeadlines):
                print(topHeadlines.status)
                self.articles = topHeadlines.articles
            case .failure(let error):
                print(error)
            }
            
            completion()
            
        }
    }
    
}
