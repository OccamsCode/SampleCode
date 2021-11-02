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
        
        // TODO: Free child
    }
    
}

/*
class DebugTask: URLSessionTaskProtocol {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}

class DebugSession: URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        let path = bundle.url(forResource: "responseTopHeadlines", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        
        return DebugTask {
            completion(data, HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil) , nil)
        }
    }
    
}
*/
