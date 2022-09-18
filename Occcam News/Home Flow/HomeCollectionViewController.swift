//
//  HomeCollectionViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import UIKit
import SafariServices

class HomeCollectionViewController: UICollectionViewController {
    
    var viewModel: HomeViewModel!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(viewModel != nil, "You forgot to attach a ViewModel")
        
        //FIXME: Localise text
        navigationItem.title = "Top Stories"
        
        // Register cell classes
        collectionView.register(cellType: ArticleCollectionViewCell.self)
        collectionView.refreshControl = refreshControl
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Latest News ...")
        
        // Do any additional setup after loading the view.
        updateUI()
        
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        updateUI()
    }
    
    func updateUI() {
        
        viewModel.update { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
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

        let cell = collectionView.dequeueReusableCell(with: ArticleCollectionViewCell.self, for: indexPath)
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return cell }
        cell.viewModel = cellViewModel
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItem(at: indexPath, given: collectionView.frame.size)
    }
    
}

// MARK:- IBInstantiatable
extension HomeCollectionViewController: IBInstantiatable {}
