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
    let tabBarController: UITabBarController
    //let navigationController: UINavigationController
    
    private let client: APIClient
    
    init(_ window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
        
        let parser = JSONParser()
        self.client = NewsClient(URLSession(configuration: .default), jsonParser: parser)
    }
    
    func start() {
        
        let homeFlow = HomeFlowCoordinator(UINavigationController(), client: client)
        let searchFlow = SearchFlowCoordinator(UINavigationController(), client: client)
        
        homeFlow.start()
        searchFlow.start()
        
        tabBarController.setViewControllers([homeFlow.navigation, searchFlow.navigation], animated: false)
        
        //let topHeadlinesFlow = NewsFlowCoordinator(navigationController)
        homeFlow.navigation.navigationBar.prefersLargeTitles = true
        
        // store child coordinator
        store(homeFlow)
        store(searchFlow)
        
        // start the coordinator
        homeFlow.start()
        
        // launch the window
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        // TODO: Free child
    }
    
    
}
