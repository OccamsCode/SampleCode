//
//  ArticleCellViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/03/2021.
//

import Foundation

class HomeArticleCellViewModel {
    
    var articles: [Article]
    
    init(_ articles: [Article]) {
        self.articles = articles
    }
    
    var numberOfSections: Int {
        return articles.isEmpty ? 0 : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return articles.count
        
    }
    
    func item(at indexPath: IndexPath) -> Article? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[indexPath.row]
        
    }
    
    func sizeOfItem(at indexPath: IndexPath, given size: (w:Double, h:Double)) -> (Double, Double) {
        
        let width = size.w
        return (w: width - 100, h: width)

    }
    
}

extension HomeArticleCellViewModel {
    
    var articleTitle: String {
        guard let article = articles.first else { fatalError("Something went wrong") }
        return article.title
    }
    
    var articleImageUrl: URL? {
        guard let article = articles.first else { fatalError("Something went wrong") }
        return article.urlToImage
    }
    
}
