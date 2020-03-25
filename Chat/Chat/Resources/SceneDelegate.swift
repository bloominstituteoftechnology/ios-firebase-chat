//
//  SceneDelegate.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
extension UINavigationController {
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().barTintColor = UIColor.link
        
        
        
            if #available(iOS 13.0, *) {
              let appearance = UINavigationBarAppearance()
              UINavigationBar.appearance().tintColor = .white
              appearance.backgroundColor = UIColor.link
              appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white] //portrait title
              appearance.titleTextAttributes = [.foregroundColor : UIColor.white] //landscape title
              UINavigationBar.appearance().tintColor = .white
              UINavigationBar.appearance().standardAppearance = appearance //landscape
              UINavigationBar.appearance().compactAppearance = appearance
              UINavigationBar.appearance().scrollEdgeAppearance = appearance //portrait
            } else {
               
              UINavigationBar.appearance().isTranslucent = false
              UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
              UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

}
