//
//  HomeCollectionViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {

    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(viewModel != nil, "You forgot to attach a ViewModel")

        // Register cell classes
        collectionView.register(cellType: TopArticleCollectionViewCell.self)
        collectionView.register(cellType: ListCollectionViewCell.self)

        // Do any additional setup after loading the view.
        
        viewModel.update { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//FIXME: Move to ViewModel
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(with: TopArticleCollectionViewCell.self, for: indexPath)
            
            guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return cell }
            cell.update(with: cellViewModel)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(with: ListCollectionViewCell.self, for: indexPath)
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return cell }
        cell.viewModel = cellViewModel
        return cell

    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK:- UICollectionViewDelegateFlowLayout
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 20
        return CGSize(width: width, height: width)
        
    }
    
}

// MARK:- IBInstantiatable
extension HomeCollectionViewController: IBInstantiatable {}
