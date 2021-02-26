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
    
    var listItemStyles: [Int: ListItemStyle]
    
    init(client: APIClient, model: [Article]) {
        self.articles = model
        self.client = client
        listItemStyles = [:]
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
    
    func styleForItem(at indexPath: IndexPath) -> ListItemStyle? {
        
        guard let _ = item(at: indexPath) else { return nil }
        
        guard let style = listItemStyles[indexPath.row] else { return .normal }
        
        return style
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> ArticleCellViewModel? {
        
        guard let item = item(at: indexPath), let style = styleForItem(at: indexPath) else { return nil }
        
        return ArticleCellViewModel(item, listStyle: style)

    }
    
    func sizeForItem(at indexPath: IndexPath, given width: Float) -> (Float, Float) {

        guard let style = styleForItem(at: indexPath) else { return (0, 0) }
        
        var paddedWidth = width - 10
        
        switch style {
        case .feature:
            return (paddedWidth, paddedWidth)
        case .subfeature:
            paddedWidth -= 5
            paddedWidth = paddedWidth / 2.0
            return (paddedWidth, paddedWidth * 1.4)
        case .normal:
            return (paddedWidth, paddedWidth / 3.5)
        }
    }
    
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
