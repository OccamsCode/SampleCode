//
//  TopHeadlineCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/02/2021.
//

import UIKit

class TopHeadlineCellViewModel {
    
    private let model: Article
    
    init(_ article: Article) {
        self.model = article
    }
    
    var title: String {
        model.title
    }
    
}

class TopHeadlineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
}
