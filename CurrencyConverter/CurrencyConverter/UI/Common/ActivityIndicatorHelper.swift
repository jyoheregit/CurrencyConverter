//
//  ActivityIndicatorHelper.swift
//  CurrencyConverter
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityIndicatorProtocol {
    var activityIndicatorView : UIActivityIndicatorView { get }
    var loadingView : UIView { get }
    var mainView : UIView {  set get}
    
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorProtocol {
    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        mainView.addSubview(loadingView)
        mainView.bringSubviewToFront(loadingView)
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}

class ActivityIndicatorHelper : ActivityIndicatorProtocol {
    
    weak var view : UIView!
    
    lazy var activityIndicatorView: UIActivityIndicatorView  = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.view.center
        return activityIndicatorView
    }()
    
    lazy var loadingView : UIView  = {
        let loadingView = UIView()
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.7
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }()
    
    var mainView: UIView {
        set {
            self.view = newValue
        }
        get {
            return self.view
        }
    }
}

