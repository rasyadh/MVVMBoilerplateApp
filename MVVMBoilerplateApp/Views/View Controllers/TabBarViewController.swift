//
//  TabBarViewController.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.blueColor
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.grayColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.blueColor], for: .selected)
        
        self.viewControllers = [
            setViewControllerTabItem(
                storyboardName: "Home",
                title: Localify.get("tab.home"),
                image: UIImage(named: "iconChatLine")!.withRenderingMode(.alwaysOriginal),
                selectedImage: UIImage(named: "iconChat")!),
            setViewControllerTabItem(
                storyboardName: "Browse",
                title: Localify.get("tab.browse"),
                image: UIImage(named: "iconChatLine")!.withRenderingMode(.alwaysOriginal),
                selectedImage: UIImage(named: "iconChat")!),
            setViewControllerTabItem(
                storyboardName: "Profile",
                title: Localify.get("tab.profile"),
                image: UIImage(named: "iconMoreLine")!.withRenderingMode(.alwaysOriginal),
                selectedImage: UIImage(named: "iconMore")!)
        ]
    }
    
    // MARK: - Private function
    private func setViewControllerTabItem(storyboardName: String, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        let viewController = UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateInitialViewController()
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        viewController?.tabBarItem = tabItem
        
        return viewController!
    }
}
