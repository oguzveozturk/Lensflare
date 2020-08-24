//
//  SceneDelegate.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.frame = UIScreen.main.bounds
            window.rootViewController = AppContainer().buildWithNavigation(ViewModel())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}


