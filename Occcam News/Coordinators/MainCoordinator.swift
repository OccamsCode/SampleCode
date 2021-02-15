//
//  MainCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    
    let window: UIWindow
    let navigationController: UINavigationController
    
    init(_ window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.childCoordinators = []
    }
    
    func start() {
        
        let topHeadlinesFlow = NewsFlowCoordinator(navigationController)
        // store child coordinator
        store(topHeadlinesFlow)
        
        // start the coordinator
        topHeadlinesFlow.start()
        
        // launch the window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // TODO: Free child
    }
    
    
}
