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
    
    private let client: APIClient
    
    init(_ window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.childCoordinators = []
        
        let parser = JSONParser()
        self.client = NewsClient(URLSession(configuration: .default), jsonParser: parser)
    }
    
    func start() {
        
        //let topHeadlinesFlow = NewsFlowCoordinator(navigationController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        let homeFlow = HomeFlowCoordinator(navigationController, client: client)
        // store child coordinator
        store(homeFlow)
        
        // start the coordinator
        homeFlow.start()
        
        // launch the window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // TODO: Free child
    }
    
    
}
