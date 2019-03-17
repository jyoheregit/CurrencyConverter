//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coordinator : Coordinator = {
        window = UIWindow()
        return AppCoordinator(window: window ?? UIWindow())
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator.launchInitialViewController()
        return true
    }
}

