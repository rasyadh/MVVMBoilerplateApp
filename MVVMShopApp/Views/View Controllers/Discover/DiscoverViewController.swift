//
//  DiscoverViewController.swift
//  MVVMShopApp
//
//  Created by Twiscode on 18/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Outlet Instance
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideNavigationBarShadow()
        omitNavBackButtonTitle()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Localify.get("discover.title")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hideNavigationBarShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
