//
//  SearchNewsTableViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit

class SearchNewsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        stackView.isHidden = true
    }
    
    func configure(with article: Article?) {
    
        // Yes this can be done using a if statement, however I prefer programming to state and optionals effectively offer state.
        switch article {
        case .none:
            stackView.isHidden = true
            activityView.startAnimating()
            
            titleLabel.text = nil
            dateLabel.text = nil
            coverImage.image = #imageLiteral(resourceName: "placeholder")
            
        case .some(let article):
            stackView.isHidden = false
            activityView.stopAnimating()
            
            titleLabel.text = article.title
            dateLabel.text = article.published_at.timeAgo()
            
            if let imageUrl = article.image_url {
            coverImage.load(url: imageUrl)
            }
            
        }
        
    }
}
