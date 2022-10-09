//
//  ArticleTableViewCell.swift
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

protocol ArticleCellDelegate: AnyObject {
    func cellDidSelectShare(_ cell: UITableViewCell)
    func cellDidSelectBookmark(_ cell: UITableViewCell)
}

protocol ArticleCellType {
    var viewModel: ArticleCellViewModel! { get set }
    var delegate: ArticleCellDelegate? { get set }
}

enum ArticleCellStyle {
    case top
    case standard
}

class ArticleTableViewCell: UITableViewCell, ArticleCellType {

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!

    @IBOutlet private weak var topStackView: UIStackView!
    
    var delegate: ArticleCellDelegate?

    var cellStyle: ArticleCellStyle = .standard {
        didSet {
            setupConstraints()
        }
    }

    var viewModel: ArticleCellViewModel! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 10.0
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        publishedDateLabel.text = nil
    }

    private func setupConstraints() {

        NSLayoutConstraint.deactivate(mainImageView.constraints)
        switch cellStyle {
        case .standard:
            topStackView.axis = .horizontal
            NSLayoutConstraint.activate([
                mainImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 110),
                mainImageView.widthAnchor.constraint(equalToConstant: 110)
            ])
        case .top:
            topStackView.axis = .vertical
            NSLayoutConstraint.activate([
                mainImageView.heightAnchor.constraint(equalToConstant: 250)
            ])
        }
    }

    func updateUI() {
        titleLabel.text = viewModel.title
        publishedDateLabel.text = viewModel.datePublished

        if let imageUrl = viewModel.imageUrl {
            mainImageView.load(url: imageUrl)
        }
    }

    @IBAction func didSelectShare(_ sender: UIButton) {
        delegate?.cellDidSelectShare(self)
    }

    @IBAction func didSelectBookmark(_ sender: UIButton) {
        delegate?.cellDidSelectBookmark(self)
    }
}
