//
//  ArticleCellViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

protocol ArticleCellDelegate {
    func didSelect(_ article: Article)
}

class HomeArticleCellViewModel {
    
    var articles: [Article]
    
    var delegate: ArticleCellDelegate?
    
    var previewActionIndexPath: IndexPath?
    
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
    
    func sizeOfItem(at indexPath: IndexPath, given size: CGSize) -> CGSize {
        
        let floord = floor(size.width / 3)
        return CGSize(width: size.width - floord, height: size.height)

    }
    
    func didSelectCellForPreviewAction(at indexPath: IndexPath) {
        previewActionIndexPath = indexPath
    }
    
    func willPerformPreviewAction() {
        
        guard let indexPath = previewActionIndexPath, let article = item(at: indexPath) else {
            return print("No article found at \(String(describing: previewActionIndexPath))")
        }
        
        delegate?.didSelect(article)
        
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
    
    var artidlePublishDate: Date {
        guard let article = articles.first else { fatalError("Something went wrong") }
        return article.publishedAt
    }
    
}

extension HomeArticleCellViewModel: ListCellDelegate {
    
    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        guard let article = item(at: indexPath) else { return print("No article found") }
        delegate?.didSelect(article)
    }
    
}
