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
    private let client: APIClient

    init(_ window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
        self.childCoordinators = []

        let parser = JSONParser()
        self.client = NewsClient(URLSession(configuration: .default), jsonParser: parser)
    }

    func start() {
        let homeNavigationController = UINavigationController()
        let searchNavigationController = UINavigationController()

        homeNavigationController.navigationBar.prefersLargeTitles = true
        searchNavigationController.navigationBar.prefersLargeTitles = true

        let homeFlow = HomeFlowCoordinator(homeNavigationController, client: client)
        let searchFlow = SearchFlowCoordinator(searchNavigationController, client: client)

        homeFlow.start()
        searchFlow.start()

        tabBarController.setViewControllers([homeNavigationController, searchNavigationController], animated: false)

        // store child coordinator
        store(homeFlow)
        store(searchFlow)

        // start the coordinator
        homeFlow.start()

        // launch the window
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

    }

    deinit {
        childCoordinators.forEach { free($0) }
    }
}
