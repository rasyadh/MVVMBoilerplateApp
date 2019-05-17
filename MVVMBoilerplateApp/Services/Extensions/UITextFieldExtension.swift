//
//  UITextFieldExtension.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

extension UITextField {
    func setGrayBorderColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.grayColor.cgColor
        self.layer.masksToBounds = true
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
