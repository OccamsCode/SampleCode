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
        tableView.register(cellType: ArticleTableViewCell.self)
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
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(with: ArticleTableViewCell.self, for: indexPath)
        cell.cellStyle = indexPath.row == 0 ? .top : .standard
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return cell }
        cell.viewModel = cellViewModel
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        guard let preview = viewModel.didSelectContextActionForItem(at: indexPath) as? UIViewController else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return preview
        }, actionProvider: nil)

    }

    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [unowned self] in
            self.viewModel.willPerformContextAction()
        }
    }
}

extension HomeViewController: IBInstantiatable {}
