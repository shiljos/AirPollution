//
//  AppDelegate.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
       
        let rootVC = ForecastViewController(ForecastPresenter())
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        
        return true
    }
}

