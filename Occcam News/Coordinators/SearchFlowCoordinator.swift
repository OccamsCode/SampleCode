//
//  SearchFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 23/03/2021.
//

import UIKit

class SearchFlowCoordinator: Coordinator {
    
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
        view.viewModel = viewModel
        navigation.setViewControllers([view], animated: false)
        
    }
    
}
