//
//  HomeViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

class HomeViewModel {
    
    private let client: APIClient
    private var articles: [String:HomeArticleCellViewModel]
    
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
    
    func cellViewModel(at indexPath: IndexPath) -> HomeArticleCellViewModel? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[sections[indexPath.section]]
        
    }
    
    func titleForHeader(at section: Int) -> String? {
        
        if section >= 0 && section < numberOfSections {
            return sections[section]
        }
        
        return nil
        
    }
    
    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        
        let width = frame.width - 20
        return CGSize(width: width, height: width)
        
    }
    
    func sizeForHeader(at section: Int, given frame: CGSize) -> CGSize  {
        
        switch section {
        case 0:
            return CGSize.zero
        default:
            let width = frame.width
            return CGSize(width: width, height: 40)
        }
        
    }
    
    func update(completion: @escaping () -> Void) {
        
        let topHeadlines = NewsAPI.topHeadlines
        
        client.fetch(from: topHeadlines, into: TopHeadlines.self) { [unowned self] result in
            
            switch result {
            case .success(let topHeadlines):
                print("Found \(topHeadlines.totalResults) articles")
                
                let top = Array(arrayLiteral: topHeadlines.articles.first!)
                
                self.articles["Top Headline"] = HomeArticleCellViewModel(top)
                self.articles["General"] = HomeArticleCellViewModel(topHeadlines.articles)
                
            case .failure(let error):
                print(error)
            }
            
            completion()
            
        }
    }
    
}
