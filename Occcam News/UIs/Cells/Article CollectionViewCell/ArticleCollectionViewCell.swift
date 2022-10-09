//
//  ArticleCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    var viewModel: ArticleCellViewModel! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10.0
    }

    func updateUI() {
        textLabel.text = viewModel.title
        dateLabel.text = viewModel.datePublished

        if let imageUrl = viewModel.imageUrl {
            imageView.load(url: imageUrl)
        }
    }

    @IBAction func bookmarkArticle(_ sender: Any) {
        Log.info("Bookmark Article")
    }

    @IBAction func shareArticle(_ sender: Any) {
        Log.info("Share Article")
    }
}
