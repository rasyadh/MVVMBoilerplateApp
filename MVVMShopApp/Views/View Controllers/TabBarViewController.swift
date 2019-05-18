//
//  TabBarViewController.swift
//  MVVMShopApp
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
                storyboardName: "Discover",
                title: Localify.get("tab.discover"),
                image: UIImage(named: "home")!,
                tag: 0),
            setViewControllerTabItem(
                storyboardName: "Shop",
                title: Localify.get("tab.shop"),
                image: UIImage(named: "search")!,
                tag: 1),
            setViewControllerTabItem(
                storyboardName: "Brands",
                title: Localify.get("tab.brands"),
                image: UIImage(named: "star")!,
                tag: 2),
            setViewControllerTabItem(
                storyboardName: "Wishlist",
                title: Localify.get("tab.wishlist"),
                image: UIImage(named: "heart")!,
                tag: 3),
            setViewControllerTabItem(
                storyboardName: "Bag",
                title: Localify.get("tab.bag"),
                image: UIImage(named: "shopping_bag")!,
                tag: 4)
        ]
    }
    
    // MARK: - Private function
    private func setViewControllerTabItem(storyboardName: String, title: String, image: UIImage, tag: Int) -> UIViewController {
        let viewController = UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateInitialViewController()
        let tabItem = UITabBarItem(title: title, image: image, tag: tag)
        viewController?.tabBarItem = tabItem
        
        return viewController!
    }
}
