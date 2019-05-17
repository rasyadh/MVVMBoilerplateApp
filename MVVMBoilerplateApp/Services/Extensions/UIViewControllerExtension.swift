//
//  UIViewControllerExtension.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

enum ToolbarPickerType {
    case gender,
    date
}

extension UIViewController {
    // MARK: - Navigation Bar
    func configureTransparentNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func hideNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func showNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    func omitNavBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func hideNavBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setBarImageView(imageName: String) -> UIBarButtonItem {
        let logo = UIImage(named: imageName)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return UIBarButtonItem(customView: logoImageView)
    }
    
    // MARK: - Tab Bar
    func showTabBarTopBorder(_ color: CGColor, _ height: CGFloat = 1.0) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
        topBorder.backgroundColor = color
        tabBarController?.tabBar.layer.addSublayer(topBorder)
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    // MARK: - Toolbar Picker
    func createToolbarPicker(_ type: ToolbarPickerType) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var done = UIBarButtonItem()
        switch type {
        case .gender:
            done = UIBarButtonItem(title: Localify.get("toolbar.done"), style: .plain, target: self, action: #selector(genderPickerTouchUpInside(_:)))
        case .date:
            done = UIBarButtonItem(title: Localify.get("toolbar.done"), style: .plain, target: self, action: #selector(datePickerTouchUpInside(_:)))
        }
        let cancel = UIBarButtonItem(title: Localify.get("toolbar.cancel"), style: .plain, target: self, action: #selector(cancelPickerTouchUpInside(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancel, space, done], animated: false)
        
        return toolbar
    }
    
    @objc func cancelPickerTouchUpInside(_ sender: Any) {
        self.view.endEditing(true)
    }
    @objc func genderPickerTouchUpInside(_ sender: Any) {}
    @objc func datePickerTouchUpInside(_ sender: Any) {}    
}
