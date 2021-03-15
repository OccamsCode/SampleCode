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
        return ["Top Headline", "general", "technology", "health"]
    }
    
    func cellViewModel(at indexPath: IndexPath) -> HomeArticleCellViewModel? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[sections[indexPath.section]]
        
    }
    
    func titleForHeader(at section: Int) -> String? {
        
        if section >= 0 && section < numberOfSections {
            return sections[section].capitalized
        }
        
        return nil
        
    }
    
    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        
        let width = frame.width - 20
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: width)
        default:
            let height = floor(width * 0.8)
            return CGSize(width: width, height: height)
        }
        
    }
    
    func sizeForHeader(at section: Int, given size: CGSize) -> CGSize  {
        
        switch section {
        case 0:
            return CGSize.zero
        default:
            let width = size.width
            return CGSize(width: width, height: 40)
        }
        
    }
    
    func update(completion: @escaping () -> Void) {
        
        let categories = sections.map {
            NewsCategory.init(rawValue: $0)
        }
        
        let group = DispatchGroup()
        
        for category in categories {
            
            guard let unwrapped = category else { continue }
            
            group.enter()
            let topHeadlines = NewsAPI.topHeadlines(unwrapped)
            
            client.fetch(from: topHeadlines, into: TopHeadlines.self) { [unowned self] result in
                
                switch result {
                case .success(let topHeadlines):
                    
                    print("Found \(topHeadlines.totalResults) articles total, returned \(topHeadlines.articles.count)")
                    
                    if unwrapped == .general {
                        let top = Array(arrayLiteral: topHeadlines.articles.first!)
                        self.articles["Top Headline"] = HomeArticleCellViewModel(top)
                    }
                    
                    self.articles[unwrapped.rawValue] = HomeArticleCellViewModel(topHeadlines.articles)
                    
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("All network requests completed")
            completion()
        }
    }
    
}
