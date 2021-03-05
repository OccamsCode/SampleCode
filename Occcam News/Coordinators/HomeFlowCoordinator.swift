//
//  HomeFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import UIKit

class HomeFlowCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    var navigation: UINavigationController
    private let client: APIClient
    
    init(_ navigationController: UINavigationController, client: APIClient) {
        self.navigation = navigationController
        self.client = client
        self.childCoordinators = []
    }
    
    func start() {
        
        let view = HomeCollectionViewController.instantiate()
        let viewModel = HomeViewModel(client: client)
        view.viewModel = viewModel
        
        navigation.setViewControllers([view], animated: false)
    }
    
}
