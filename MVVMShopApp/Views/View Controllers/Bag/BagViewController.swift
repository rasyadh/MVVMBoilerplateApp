//
//  BagViewController.swift
//  MVVMShopApp
//
//  Created by Twiscode on 18/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

class BagViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        omitNavBackButtonTitle()
        hideNavigationBarShadow()
        navigationItem.title = Localify.get("bag.title")
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
