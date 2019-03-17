//
//  ToolbarPickerView.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {
    
    public private(set) lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        return toolbar
    }()
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
    }
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
