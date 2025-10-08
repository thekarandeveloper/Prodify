//
//  SceneDelegate.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
   
        private weak var noInternetVC: NoInternetViewController?
        
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "rootNavigation")
            window?.makeKeyAndVisible()
            
            setupNetworkMonitoring()
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            print("Scene became active - force checking network")
            // App foreground pe aaye toh force check
            NetworkMonitor.shared.forceCheck()
        }
        
        private func setupNetworkMonitoring() {
            NetworkMonitor.shared.onStatusChanged = { [weak self] isConnected in
                print("Callback: \(isConnected)")
                
                if isConnected {
                    self?.dismissNoInternet()
                } else {
                    self?.showNoInternet()
                }
            }
            
            // Initial check - with correct status
            print("Initial status check: \(NetworkMonitor.shared.isConnected)")
            if !NetworkMonitor.shared.isConnected {
                showNoInternet()
            }
        }
        
        private func showNoInternet() {
            print("showNoInternet called")
            
            if noInternetVC != nil {
                return
            }
            
            guard let window = window,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            
            guard let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController else {
                print("Could not instantiate NoInternetViewController")
                return
            }
            
            vc.modalPresentationStyle = .formSheet
            vc.isModalInPresentation = true
            
            noInternetVC = vc
            
            topVC.present(vc, animated: true) {
                print("Presented NoInternetViewController")
            }
        }
        
        private func dismissNoInternet() {

            guard let vc = noInternetVC else {
                print("No VC to dismiss")
                return
            }
            
            vc.dismiss(animated: true) { [weak self] in
                self?.noInternetVC = nil
            }
        }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
