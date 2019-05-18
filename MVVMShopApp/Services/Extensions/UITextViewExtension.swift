//
//  UITextViewExtension.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

extension UITextView {
    func setGrayBorderColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.grayColor.cgColor
        self.layer.masksToBounds = true
    }
}
