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
        
        imageView.layer.cornerRadius = 25.0
    }

    func update(with viewModel: HomeArticleCellViewModel) {
        
        textLabel.text = viewModel.articleTitle
        
        if let url = viewModel.articleImageUrl {
            
            imageView.setImage(from: url) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
        }
        
    }
}
