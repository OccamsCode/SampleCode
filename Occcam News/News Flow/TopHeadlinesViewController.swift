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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHeadlinesCollectionViewCell", for: indexPath) as? TopHeadlineCollectionViewCell else {
            fatalError("Did not deque cell")
        }
        
        guard let topHeadline = viewModel.viewModelForItem(at: indexPath) else { fatalError("Other") }
        
        cell.update(topHeadline)
        
        return cell
    }
    
}

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = viewModel.sizeForItem(at: indexPath, given: Float(collectionView.frame.width))
        
        return CGSize(width: CGFloat(itemSize.0), height: CGFloat(itemSize.1))

    }

}

extension TopHeadlinesViewController: IBInstantiatable {
    static var instantiateType: IBInstanceType { return .storyboardInitial }
}
