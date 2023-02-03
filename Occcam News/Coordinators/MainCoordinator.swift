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
    private let client: Client

    init(_ window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
        self.childCoordinators = []

        if ProcessInfo.processInfo.arguments.contains("--uitest") {
            self.client = NewAPIClient(environment: Environment.testing, urlSession: URLSession.shared)
        } else {
            let env = Environment(scheme: .secure,
                                  endpoint: "api.thenewsapi.com",
                                  addtionalHeaders: [:],
                                  port: nil)
            self.client = NewAPIClient(environment: env, urlSession: URLSession.shared)
        }
    }

    func start() {
        let homeNavigationController = UINavigationController()
        // let searchNavigationController = UINavigationController()

        homeNavigationController.navigationBar.prefersLargeTitles = true
        // searchNavigationController.navigationBar.prefersLargeTitles = true

        let homeFlow = HomeFlowCoordinator(homeNavigationController, client: client)
        // let searchFlow = SearchFlowCoordinator(searchNavigationController, client: client)

        homeFlow.start()
        // searchFlow.start()

        tabBarController.setViewControllers([homeNavigationController], animated: false)

        // store child coordinator
        store(homeFlow)
        // store(searchFlow)

        // launch the window
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

    }

    deinit {
        childCoordinators.forEach { free($0) }
    }
}
