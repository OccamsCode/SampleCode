//
//  SearchFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit
import SafariServices

class SearchFlowCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator]
    
    let navigation: UINavigationController
    private let client: APIClient
    
    init(_ navigationController: UINavigationController, client: APIClient) {
        self.navigation = navigationController
        self.client = client
        self.childCoordinators = []
    }
    
    func start() {
        
        let view =  ViewControllerFactory.produce(SearchNewsTableViewController.self)
        view.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let viewModel =  SearchNewsViewModel(client: client)
        viewModel.coordinator = self
        view.viewModel = viewModel
        navigation.setViewControllers([view], animated: false)
        
    }
    
    func display(_ article: Article) {
        
        let view = ViewControllerFactory.produce(safariControllerFrom: article)
        view.delegate = self
        view.modalPresentationStyle = .overCurrentContext
        navigation.present(view, animated: true, completion: nil)
        
    }
    
}

extension SearchFlowCoordinator: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigation.dismiss(animated: true, completion: nil)
    }
    
}
