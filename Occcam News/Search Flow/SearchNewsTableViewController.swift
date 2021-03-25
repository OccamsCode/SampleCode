//
//  SearchNewsTableViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit

class SearchNewsTableViewController: UITableViewController {
    
    var viewModel: SearchNewsViewModel!
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(viewModel != nil, "You forgot to attach a ViewModel")
        
        tableView.register(cellType: SearchNewsTableViewCell.self)
        tableView.prefetchDataSource = self
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expectedTotalResults
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: SearchNewsTableViewCell.self, for: indexPath)
        
        //FIXME: Move to CellVM
        
        if isLoadingCell(for: indexPath) {
            cell.titleLabel.text = "waiting.."
            } else {
                guard let article = viewModel.article(at: indexPath) else { fatalError() }
                cell.titleLabel.text = article.title
            }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForCell(at: indexPath, given: tableView.frame.width)
    }

}

extension SearchNewsTableViewController: UITableViewDataSourcePrefetching {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.numberOfItems(in: indexPath.section)
      }

      func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
      }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.loadMore { [unowned self] newIndexPaths in
                
                guard let newIndexPaths = newIndexPaths else { return }
                DispatchQueue.main.async {
                    let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPaths)
                    self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
                }
                
            }
        }
    }
    
    
}

extension SearchNewsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.search(for: text) { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchNewsTableViewController: IBInstantiatable {}
