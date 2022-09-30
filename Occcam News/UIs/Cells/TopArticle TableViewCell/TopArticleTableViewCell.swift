//
//  TopArticleTableViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/09/2022.
//

import UIKit

class ArticleCellViewModel {

    private let article: Article

    init (_ article: Article) {
        self.article = article
    }

    var title: String {
        return article.title
    }

    var datePublished: String {
        return article.publishedAt.timeAgo()
    }

    var imageUrl: URL? {
        return article.imageUrl
    }
}

class TopArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!

    var viewModel: ArticleCellViewModel! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 10.0
    }

    func updateUI() {
        titleLabel.text = viewModel.title
        publishedDateLabel.text = viewModel.datePublished

        if let imageUrl = viewModel.imageUrl {
            mainImageView.load(url: imageUrl)
        }
    }

    @IBAction func didSelectShare(_ sender: UIButton) {
    }

    @IBAction func didSelectBookmark(_ sender: UIButton) {
    }
}
