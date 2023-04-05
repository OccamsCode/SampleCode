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
        // FIXME: Localise text
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController

        // FIXME: Localise text
        navigationItem.title = "Discover"
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

        let article = isLoadingCell(for: indexPath) ? .none : viewModel.article(at: indexPath)
        cell.configure(with: article)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForCell(at: indexPath, given: tableView.frame.width)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }

    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        guard let preview = viewModel.didSelectContextActionForItem(at: indexPath) as? UIViewController else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return preview
        }, actionProvider: nil)

    }

    override func tableView(_ tableView: UITableView,
                            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [unowned self] in
            self.viewModel.willPerformContextAction()
        }
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
