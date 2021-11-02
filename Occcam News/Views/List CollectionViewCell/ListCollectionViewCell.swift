//
//  ListCollectionViewCell.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit

protocol ListCellDelegate: class {
    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath)
}

protocol ListCellViewModelDelegate: AnyObject {

    func listCell(_ cell: ListCollectionViewCell, didSelectItemAtIndexPath indexPath: IndexPath)
    func listCell(_ cell: ListCollectionViewCell, generatePreviewForItemAtIndexPath indexPath: IndexPath) -> Previewable
    func listCellCommitPreviewAction(_ cell: ListCollectionViewCell)
}

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel: SectionListViewModel! {
        didSet {
            delegate = viewModel
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var delegate: ListCellViewModelDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellType: ArticleCollectionViewCell.self)
        
        if let layout = collectionView?.collectionViewLayout as? SnapCollectionFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }

}

extension ListCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let preview = delegate?.listCell(self, generatePreviewForItemAtIndexPath: indexPath) as? UIViewController else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return preview
        }, actionProvider: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion { [unowned self] in
            delegate?.listCellCommitPreviewAction(self)
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
            cell.imageView.load(url: imageUrl)
        }
        
        return cell
    }
    
}

extension ListCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfItem(at: indexPath, given: collectionView.frame.size)
    }

}
