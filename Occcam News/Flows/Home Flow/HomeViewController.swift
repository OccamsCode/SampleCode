//
//  HomeViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/09/2022.
//

import UIKit

class HomeViewController: UIViewController {

    var viewModel: HomeViewModel!
    @IBOutlet private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        precondition(viewModel != nil, "You forgot to attach a ViewModel")

// FIXME: Localise text
        navigationItem.title = "Top Stories"

        // Register cell classes
        tableView.register(cellType: TopArticleTableViewCell.self)
        //collectionView.register(cellType: ArticleCollectionViewCell.self)
        tableView.refreshControl = refreshControl

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Latest News ...")     // FIXME: Localise text

        // Do any additional setup after loading the view.
        updateUI()
    }

    @objc func refreshData(_ sender: UIRefreshControl) {
        updateUI()
    }

    func updateUI() {
        viewModel.update { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TopArticleTableViewCell.self, for: indexPath)
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return cell }
        cell.viewModel = cellViewModel
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
}

extension HomeViewController: IBInstantiatable {}
