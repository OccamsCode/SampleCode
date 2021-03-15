//
//  TopHeadlinesViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import CoreGraphics.CGGeometry

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
    
    func viewModelForItem(at indexPath: IndexPath) -> OldArticleCellViewModel? {
        
        guard let item = item(at: indexPath), let style = styleForItem(at: indexPath) else { return nil }
        
        return OldArticleCellViewModel(item, listStyle: style)

    }
    
    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {

        guard let style = styleForItem(at: indexPath) else { return CGSize.zero }
        
        var paddedWidth = frame.width - 10
        
        switch style {
        case .feature:
            return CGSize(width: paddedWidth, height: paddedWidth + 140)
        case .subfeature:
            paddedWidth -= 5
            paddedWidth = paddedWidth / 2.0
            return CGSize(width: paddedWidth, height: paddedWidth + 120)
        case .normal:
            return CGSize.zero
//            let floored = floorf(paddedWidth / 3)
//            return (paddedWidth, floored)
        }
    }
    
    func update(completion: @escaping () -> Void) {
        
        let topHeadlines = NewsAPI.topHeadlines(.general)
        
        client.fetch(from: topHeadlines, into: TopHeadlines.self) { (result) in
            
            switch result {
            case .success(let topHeadlines):
                print("Found \(topHeadlines.totalResults) articles")
                self.articles = topHeadlines.articles
            case .failure(let error):
                print(error)
            }
            
            completion()
            
        }
    }
    
}
