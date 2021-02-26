//
//  FeaturedArticleCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/02/2021.
//

import UIKit

class ArticleCellViewModel {
    
    let listStyle: ListItemStyle
    
    private let model: Article
    
    init(_ article: Article, listStyle: ListItemStyle) {
        self.model = article
        self.listStyle = listStyle
    }
    
    var articleTitle: String {
        return model.title
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

class FeaturedArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 5.0
    }
    
    func update(_ viewModel: ArticleCellViewModel) {
        
        textLabel.text = viewModel.articleTitle
        textLabel.font = UIFont.boldSystemFont(ofSize: viewModel.fontSize)
        
        if let url = viewModel.articleImage {
            
            imageView.setImage(from: url) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
        }
        
    }
    
}

// TODO - Refactor This
extension UIImageView {
    
    func setImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        
        let session = URLSession(configuration: .default)
        
        image = #imageLiteral(resourceName: "placeholder")
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let urlImage = UIImage(data: data) else { return print("No Image Data") }
            completion(urlImage)
        }
        
        dataTask.resume()
        
    }
    
}
