//
//  TopHeadlinesViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

class TopHeadlinesViewModel {
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfItems(in section: Int) -> Int {
        return 10
    }
    
    func item(at indexPath: IndexPath) -> Int {
        return (indexPath.section + 1) * indexPath.row
    }
    
}
