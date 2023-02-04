//
//  HomeFlowCoordinator.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import SafariServices
import UIKit

class HomeFlowCoordinator: NSObject, Coordinator {

    var childCoordinators: [Coordinator]
    var navigation: UINavigationController
    private let client: Client

    init(_ navigationController: UINavigationController, client: Client) {
        self.navigation = navigationController
        self.client = client
        self.childCoordinators = []
    }

    func start() {
        let view = ViewControllerFactory.produce(HomeViewController.self)
        let viewModel = HomeViewModel(client: client)
        viewModel.coordinator = self
        view.viewModel = viewModel

        // FIXME: Create Image Resources
        view.tabBarItem = UITabBarItem(title: HomeViewModel.Constants.tabBarTitle,
                                       image: UIImage(systemName: "newspaper"),
                                       selectedImage: UIImage(systemName: "newspaper.fill"))

        navigation.setViewControllers([view], animated: false)
    }

    func navigate(_ toType: Navigate) {
        switch toType {
        case .toArticle(let article):
            let preview = ViewControllerFactory.produce(safariControllerFrom: article)
            navigate(.toPreview(preview))
        case .toPreview(let preview):
            if let previewingController = preview as? SFSafariViewController {
                previewingController.delegate = self
                previewingController.modalPresentationStyle = .overCurrentContext
                navigation.present(previewingController, animated: true, completion: nil)
            }
        }
    }

    deinit {
        childCoordinators.forEach { free($0) }
    }

}

extension HomeFlowCoordinator: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigation.dismiss(animated: true, completion: nil)
    }

}
