//
//  SceneDelegate.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var mainCoordinator: MainCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {

            let window = UIWindow(windowScene: windowScene)
            mainCoordinator = MainCoordinator(window)
            mainCoordinator.start()
        }
    }

}

