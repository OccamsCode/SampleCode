//
//  TopHeadlinesViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import UIKit

class TopHeadlinesViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel: TopHeadlinesViewModel!
    
    override func viewDidLoad() {
        
        precondition(viewModel != nil, "You forgot to attach a ViewModel")
        
        viewModel.update { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension TopHeadlinesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLDArticleCollectionViewCell", for: indexPath) as? OldArticleCollectionViewCell else { fatalError("Cell Dequeing") }
        
        guard let topHeadline = viewModel.viewModelForItem(at: indexPath) else { fatalError("Other") }
        
        cell.update(with: topHeadline)
        
        return cell
    }
    
}

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return viewModel.sizeForItem(at: indexPath, given: collectionView.frame.size)

    }

}

extension TopHeadlinesViewController: IBInstantiatable {
    static var instantiateType: IBInstanceType { return .storyboardInitial }
}
