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
    
    init(_ window: UIWindow) {
        self.window = window
        childCoordinators = []
    }
    
    func start() {
        
        // preparing root view
        let navigationController = UINavigationController()
        
        // store child coordinator
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
    
}
