//
//  Resuable.swift
//  CurrencyConverter
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {}

extension Reusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(cell : T.Type) {
        register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(cell : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Dequeue Cell Failed")
        }
        return cell
    }
}
