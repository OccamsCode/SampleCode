//
//  NewsFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

class NewsFlowCoordinator: Coordinator {
    
    let navigation: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigation = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        
        let view = TopHeadlinesViewController.instantiate()
        let parser = JSONParser()
        let client = NewsClient(URLSession(configuration: .default), jsonParser: parser)
        let viewModel =  TopHeadlinesViewModel(client: client, model: [1, 2, 3])
        view.viewModel = viewModel
        navigation.setViewControllers([view], animated: false)
        
    }
    
}
