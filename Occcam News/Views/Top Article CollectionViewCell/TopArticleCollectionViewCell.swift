//
//  TopArticleCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit

class TopArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 25.0
    }

    func update(with viewModel: HomeArticleCellViewModel) {
        
        //FIXME: Change the fatal error
        guard let article = viewModel.item(at: IndexPath(item: 0, section: 0)) else { fatalError() }
        
        textLabel.text = article.title
        
        dateLabel.text = article.publishedAt.timeAgo()
        
        if let url = article.urlToImage {
            imageView.load(url: url)
        }
        
    }
}
