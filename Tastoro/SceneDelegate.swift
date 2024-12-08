//
//  SceneDelegate.swift
//  Tastoro
//
//  Created by Rangga Biner on 03/12/24.
//

// SceneDelegate.swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: MealRouter.createModule())
        self.window = window
        window.makeKeyAndVisible()
    }
}
