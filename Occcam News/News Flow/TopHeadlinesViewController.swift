//
//  TopHeadlinesViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import UIKit

class TopHeadlinesViewController: UIViewController {
    
    var viewModel: TopHeadlinesViewModel!
    
    override func viewDidLoad() {
        precondition(viewModel != nil, "You forgot to attach a ViewModel")
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHeadlinesCollectionViewCell", for: indexPath)
        
        if cell.backgroundColor != UIColor.white {
            cell.backgroundColor = .random
        }
        
        return cell
    }
    
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

extension TopHeadlinesViewController: IBInstantiatable {
    static var instantiateType: IBInstanceType { return .storyboardInitial }
}
