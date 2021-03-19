//
//  HomeFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import SafariServices
import UIKit

class HomeFlowCoordinator:NSObject, Coordinator {
    
    var childCoordinators: [Coordinator]
    
    var navigation: UINavigationController
    private let client: APIClient
    
    init(_ navigationController: UINavigationController, client: APIClient) {
        self.navigation = navigationController
        self.client = client
        self.childCoordinators = []
    }
    
    func start() {
        
        let view = HomeCollectionViewController.instantiate()
        let viewModel = HomeViewModel(client: client)
        viewModel.coordinator = self
        view.viewModel = viewModel
        
        navigation.setViewControllers([view], animated: false)
    }
    
    func display(_ article: Article) {
        
        let view = SFSafariViewController(url: article.url)
        view.delegate = self
        view.modalPresentationStyle = .overCurrentContext
        navigation.present(view, animated: true, completion: nil)
        
    }
    
}

extension HomeFlowCoordinator: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigation.dismiss(animated: true, completion: nil)
    }
    
}
