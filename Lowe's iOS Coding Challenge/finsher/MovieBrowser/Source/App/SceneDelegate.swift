//
//  SceneDelegate.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// 1. Capture the scene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        /// 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
        let window = UIWindow(windowScene: windowScene)

        /// 3. Create a view hierarchy programmatically
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
        let navigation = UINavigationController(rootViewController: viewController)

        /// 4. Set the root view controller of the window with your view controller
        window.rootViewController = navigation

        /// 5. Set the window and call makeKeyAndVisible()
        self.window = window
        window.makeKeyAndVisible()
    }
}
