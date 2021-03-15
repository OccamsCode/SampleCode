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

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel: HomeArticleCellViewModel!
    
    var delegate: ListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellType: ArticleCollectionViewCell.self)
        
        if let layout = collectionView?.collectionViewLayout as? SnapCollectionFlowLayout {
            layout.scrollDirection = .horizontal
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

        //let size = (w: Double(collectionView.frame.width), h: Double(collectionView.frame.height))
        return viewModel.sizeOfItem(at: indexPath, given: collectionView.frame.size)
        //return CGSize(width: w, height: h)

    }

}

extension ListCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listCell(self, didSelectItemAtIndexPath: indexPath)
    }
}
