//
//  AppDelegate.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = QuotesListViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.view.backgroundColor = .white
        nc.setNavigationBarHidden(false, animated: false)
        
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
