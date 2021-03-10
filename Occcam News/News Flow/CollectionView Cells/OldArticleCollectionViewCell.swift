//
//  ArticleCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 26/02/2021.
//

import UIKit

class OldArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var stackView: UIStackView!
    
    func configuireUI(given style: ListItemStyle) {
        
        imageView.layer.cornerRadius = 10.0
 
        switch style {
        case .feature, .subfeature:
            stackView.axis = .vertical
            
        case .normal:
            stackView.axis = .horizontal
        }

    }
    
    func update(with viewModel: OldArticleCellViewModel) {

        configuireUI(given: viewModel.listStyle)
        
        textLabel.text = viewModel.articleTitle
        textLabel.font = viewModel.expectedFont
        
       if let url = viewModel.articleImage {
            
        imageView.setImage(from: url) { urlImage in
            DispatchQueue.main.async {
                self.imageView.image = urlImage
            }
        }
            
        }
    }
}


class OldArticleCellViewModel {
    
    let listStyle: ListItemStyle
    
    private let model: Article
    
    init(_ article: Article, listStyle: ListItemStyle) {
        self.model = article
        self.listStyle = listStyle
    }
    
    var articleTitle: String {
        return model.title
    }
    
    var expectedFont: UIFont {
        
        switch listStyle {
        case .feature: return .preferredFont(forTextStyle: .title1)
        case .subfeature: return .preferredFont(forTextStyle: .headline)
        case .normal: return .preferredFont(forTextStyle: .body)

        }
        
    }
    
    var fontSize: CGFloat {
        
        switch listStyle {
        case .feature: return 16.0
        case .subfeature, .normal: return 12.0
        }
        
    }
    
    var articleImage: URL? {
        return model.urlToImage
    }
    
}

// TODO: - Refactor this to something more robust
extension UIImageView {
    
    func setImage(from url: URL, completion: @escaping (UIImage) -> ()) {
        
        let session = URLSession.shared
        
        image = #imageLiteral(resourceName: "placeholder")
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let urlImage = UIImage(data: data) else { return print("No Image Data") }
            
            completion(urlImage)
        }
        
        dataTask.resume()
        
    }
    
}
