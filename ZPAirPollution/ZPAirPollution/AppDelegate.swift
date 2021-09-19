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
       
        let vc = ForecastViewController()
        vc.forecastPresenter = ForecastPresenter(WeatherApiService())
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        return true
    }
}

