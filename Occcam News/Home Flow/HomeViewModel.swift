//
//  HomeViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

enum HomeSection: Int {
    case top = 0
    case other
}

class HomeViewModel {
    
    private let client: APIClient
    private var articles: [String:HomeArticleCellViewModel]
    private(set) public var selectedContextActionIndexPath: IndexPath?
    
    weak var coordinator: HomeFlowCoordinator?
    
    init(client: APIClient, article: [String:HomeArticleCellViewModel] = [:]) {
        self.client = client
        self.articles = article
    }
    
    var numberOfSections: Int {
        articles.isEmpty ? 0 : articles.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return 1
        
    }
    
    //FIXME: Find a way to inject this
    var sections: [String] {
        return ["Top Headline", "general", "technology", "health"]
        // business, entertainment, general, health, science, sports, technology
    }
    
    func cellViewModel(at indexPath: IndexPath) -> HomeArticleCellViewModel? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        let articleViewModel = articles[sections[indexPath.section]]
        articleViewModel?.delegate = self
        return articleViewModel
        
    }
    
    func titleForHeader(at section: Int) -> String? {
        
        if section >= 0 && section < numberOfSections {
            return sections[section].capitalized
        }
        
        return nil
        
    }
    
    func sectionType(for index: Int) -> HomeSection {
        return HomeSection(rawValue: index) ?? .other
    }
    
    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        
        let section = sectionType(for: indexPath.section)
        
        let width = frame.width - 20
        switch section {
        case .top:
            return CGSize(width: width, height: width)
        case .other:
            let height = floor(width * 0.8)
            return CGSize(width: width, height: height)
        }
        
    }
    
    func sizeForHeader(at section: Int, given size: CGSize) -> CGSize  {
        
        let sectiontype = sectionType(for: section)
        
        switch sectiontype {
        case .top:
            return CGSize.zero
        case .other:
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
            let topHeadlines = NewsAPI.topHeadlines(api: unwrapped, page: 1, pageSize: 10)
            
            client.fetch(from: topHeadlines, into: TopHeadlines.self) { [unowned self] result in
                
                switch result {
                case .success(let topHeadlines):
                    
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
    
    func didSelectItem(at indexPath: IndexPath) {
        
        let section = sectionType(for: indexPath.section)
        
        switch section {
        case .top:
            guard let article = cellViewModel(at: indexPath)?.item(at: IndexPath(row: 0, section: 0)) else { return }
            coordinator?.display(article)
        case .other:
            break
        }
    }
    
    func didSelectContextActionForItem(at indexPath: IndexPath) {
        selectedContextActionIndexPath = indexPath
    }
    
    func willPerformContextAction() {
        
        //FIXME: Finish the Fatal Error message
        guard let indexPath = selectedContextActionIndexPath, let article = cellViewModel(at: indexPath)?.item(at: IndexPath(row: 0, section: 0)) else { fatalError() }
        didSelect(article)
        
    }
    
}

extension HomeViewModel: ArticleCellDelegate {
    
    func didSelect(_ article: Article) {
        coordinator?.display(article)
    }
    
}
