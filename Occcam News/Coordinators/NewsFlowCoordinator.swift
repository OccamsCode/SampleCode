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
        let viewModel =  TopHeadlinesViewModel()
        view.viewModel = viewModel
        navigation.viewControllers = [view]
        
    }
    
}
