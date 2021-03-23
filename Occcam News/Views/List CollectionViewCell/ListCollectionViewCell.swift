//
//  ListCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit
import SafariServices

protocol ListCellDelegate: class {
    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath)
}

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel: HomeArticleCellViewModel! {
        didSet {
            delegate = viewModel
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var delegate: ListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellType: ArticleCollectionViewCell.self)
        
        if let layout = collectionView?.collectionViewLayout as? SnapCollectionFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func makeContextMenu() -> UIMenu {
        
        // Create a UIAction for sharing
        let share = UIAction(title: "Something") { action in
            print("Something")
        }
        
        // Create and return a UIMenu with the share action
        return UIMenu(title: "Main Menu", children: [share])
    }

}

extension ListCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        viewModel.didSelectCellForPreviewAction(at: indexPath)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            
            guard let article = self.viewModel.item(at: indexPath) else { return nil }
            // TODO:- Move to factory pattery
            return SFSafariViewController(url: article.url)
        }, actionProvider: { suggestedActions in

            return self.makeContextMenu()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion { [unowned self] in
            viewModel.willPerformPreviewAction()
        }
        
    }
    
}

extension ListCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(with: ArticleCollectionViewCell.self, for: indexPath)
        
        guard let article = viewModel.item(at: indexPath) else { return cell }
        
        // TODO: Move to view model
        cell.textLabel.text = article.title
        cell.dateLabel.text = article.publishedAt.timeAgo()
        
        if let imageUrl = article.urlToImage {
            cell.imageView.setImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
        
        return cell
    }
    
}

extension ListCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfItem(at: indexPath, given: collectionView.frame.size)
    }

}
