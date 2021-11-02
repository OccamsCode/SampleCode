//
//  SectionListViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 05/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

protocol SectionViewModelDelegate: AnyObject {
    func didSelect(_ article: Article)
    func commitAction(forPreview preview: Previewable)
}


class SectionListViewModel {
    
    let articles: [Article]
    
    private(set) var generatedPreview: Previewable!
    
    weak var delegate: SectionViewModelDelegate?
    
    init(with articles: [Article]) {
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
        
        switch item(at: indexPath) {
        case .none:
            return CGSize.zero
        case .some(_):
            let floord = floor(size.width / 3)
            return CGSize(width: size.width - floord, height: size.height)
        }

    }
    
}

extension SectionListViewModel: ListCellViewModelDelegate {
    
    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        guard let article = item(at: indexPath) else { fatalError() }
        delegate?.didSelect(article)
    }
    
    func listCell(_ cell: ListCollectionViewCell, generatePreviewForItemAtIndexPath indexPath: IndexPath) -> Previewable {
        
        guard let article = item(at: indexPath) else { fatalError() }
        generatedPreview = ViewControllerFactory.preview(for: article)
        return generatedPreview
    }
    
    func listCellCommitPreviewAction(_ cell: ListCollectionViewCell) {
        delegate?.commitAction(forPreview: generatedPreview)
    }
    
}

/*
class HomeArticleCellViewModel {
    
    var articles: [Article]
    
    var delegate: ArticleCellDelegate?
    
    var selectedContextActionIndexPath: IndexPath?
    
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
        
        switch item(at: indexPath) {
        case .none:
            return CGSize.zero
        case .some(_):
            let floord = floor(size.width / 3)
            return CGSize(width: size.width - floord, height: size.height)
        }

    }
    
    func didSelectCellForContextAction(at indexPath: IndexPath) {
        selectedContextActionIndexPath = indexPath
    }
    
    func willPerformContextAction() {
        
        guard let indexPath = selectedContextActionIndexPath, let article = item(at: indexPath) else {
            return print("No article found at \(String(describing: selectedContextActionIndexPath))")
        }
        
        delegate?.didSelect(article)
        
    }
    
}

extension HomeArticleCellViewModel: ListCellDelegate {
    
    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        guard let article = item(at: indexPath) else { return print("No article found") }
        delegate?.didSelect(article)
    }
    
}
*/
