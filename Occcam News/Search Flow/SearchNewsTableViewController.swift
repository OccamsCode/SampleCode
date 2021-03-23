//
//  SearchNewsTableViewController.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit

class SearchNewsTableViewController: UITableViewController {
    
    var viewModel: SearchNewsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(viewModel != nil, "You forgot to attach a ViewModel")
        
        tableView.register(cellType: SearchNewsTableViewCell.self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: SearchNewsTableViewCell.self, for: indexPath)
        
        //FIXME: Move to VM
        guard let article = viewModel.article(at: indexPath) else { fatalError() }
        
        cell.titleLabel.text = article.title
        
        return cell
        
    }

}

extension SearchNewsTableViewController: IBInstantiatable {}
