//
//  NewsFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

class NewsFlowCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    let navigation: UINavigationController
    private let client: APIClient
    
    init(_ navigationController: UINavigationController, client: APIClient) {
        self.navigation = navigationController
        self.client = client
        self.childCoordinators = []
    }
    
    func start() {
        
        let view =  ViewControllerFactory.produce(TopHeadlinesViewController.self) //TopHeadlinesViewController.instantiate()
        let viewModel =  TopHeadlinesViewModel(client: client, model: [])
        viewModel.listItemStyles = [0:.feature, 1:.subfeature, 2:.subfeature]
        view.viewModel = viewModel
        navigation.setViewControllers([view], animated: false)
        
    }
    
}
