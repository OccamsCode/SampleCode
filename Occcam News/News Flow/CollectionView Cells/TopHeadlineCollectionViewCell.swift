//
//  TopHeadlineCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/02/2021.
//

import UIKit

class TopHeadlineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.layer.cornerRadius = 2.5
    }
}
