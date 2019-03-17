//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var window : UIWindow { get set }
    func launchInitialViewController()
}

extension Coordinator {
    func launchInitialViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? CurrencyConverterViewController else {
            fatalError("Initial VC not instantiated")
        }
        vc.service = WebService(cacheManager: CacheManager(cache: Cache()))
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
    }
}

class AppCoordinator : Coordinator {
    var window : UIWindow
    
    init(window : UIWindow) {
        self.window = window
    }
}
