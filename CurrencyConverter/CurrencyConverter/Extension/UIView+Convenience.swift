//
//  UIView+Convenience.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var height : CGFloat { return self.frame.size.height }
    var width : CGFloat { return self.frame.size.width }
}

extension CALayer {
    func cgborderColorFromUIColor(color: UIColor) {
        self.borderColor = color.cgColor
    }
}
