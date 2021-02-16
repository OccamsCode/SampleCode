//
//  TopHeadlinesViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

class TopHeadlinesViewModel {
    
    private var items: [Int]
    
    init(model: [Int]) {
        self.items = model
    }
    
    var numberOfSections: Int {
        items.isEmpty ? 0 : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        if section < 0 || section >= numberOfSections { return 0 }
        return items.count
        
    }
    
    func item(at indexPath: IndexPath) -> Int? {
        
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return items[indexPath.row]
        
    }
    
}
