//
//  ArticleCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 26/02/2021.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let placeholder = UIImage(imageLiteralResourceName: "placeholder")
        let imageView = UIImageView(image: placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGreen
        label.text = "Article Title"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .magenta
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Last Updated"
        return label
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var subStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configuireUI(given style: ListItemStyle) {
 
        addSubview(stackView)

        textLabel.removeFromSuperview()
        dateLabel.removeFromSuperview()
        imageView.removeFromSuperview()
        
        // Constraints
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(dateLabel.heightAnchor.constraint(equalToConstant: 14))
        
        switch style {
        case .feature, .subfeature:
            
            subStackView.removeFromSuperview()
            
            constraints.append(textLabel.heightAnchor.constraint(equalToConstant: 60))
            
            stackView.axis = .vertical
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(textLabel)
            stackView.addArrangedSubview(dateLabel)
            
        case .normal:
            
            constraints.append(imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1))
            
            subStackView.addArrangedSubview(textLabel)
            subStackView.addArrangedSubview(dateLabel)

            stackView.axis = .horizontal
            stackView.addArrangedSubview(subStackView)
            stackView.addArrangedSubview(imageView)
            
        }
        
        
        let top = stackView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        constraints.append(contentsOf: [top, bottom, trailing, leading])
        
        addConstraints(constraints)
        
    }
    
    func update(with viewModel: ArticleCellViewModel) {
        
        configuireUI(given: viewModel.listStyle)
        
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
