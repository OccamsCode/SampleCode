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
    private var articles: [String:SectionListViewModel]
    
    weak var coordinator: HomeFlowCoordinator?
    
    init(client: APIClient, article: [String:SectionListViewModel] = [:]) {
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
    var sections: [String] = []
    
    func cellViewModel(at indexPath: IndexPath) -> SectionListViewModel? {
        
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
    
    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        
        switch titleForHeader(at: indexPath.section) {
        case .none:
            return CGSize.zero
        case .some(_):
            let width = frame.width - 20
            let height = floor(width * 0.8)
            return CGSize(width: width, height: height)
        }
        
    }
    
    func sizeForHeader(at section: Int, given size: CGSize) -> CGSize  {
        
        switch titleForHeader(at: section) {
        case .none:
            return CGSize.zero
        case .some(_):
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
                    
                    self.articles[unwrapped.rawValue] = SectionListViewModel(with: topHeadlines.articles)
                    
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            completion()
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        //        let section = sectionType(for: indexPath.section)
        //
        //        switch section {
        //        case .top:
        //            guard let article = cellViewModel(at: indexPath)?.item(at: IndexPath(row: 0, section: 0)) else { return }
        //            coordinator?.display(article)
        //        case .list, .none:
        //            break
        //        }
    }
    
}

extension HomeViewModel: SectionViewModelDelegate {
    
    func didSelect(_ article: Article) {
        coordinator?.navigate(.toArticle(article))
    }
    
    func commitAction(forPreview preview: Previewable) {
        coordinator?.navigate(.toPreview(preview))
    }
    
}
