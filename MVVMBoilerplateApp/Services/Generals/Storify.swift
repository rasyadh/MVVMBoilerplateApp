//
//  Storify.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

struct Preferences {
    static let badgeAppIcon = "badge_app_icon"
    static let language = "language"
    static let isFirstLaunch = "is_first_launch"
    static let isLoggedIn = "is_logged_in"
    static let tokenLogin = "token_login"
    static let tokenRefresh = "token_refresh"
    static let userData = "user_data"
}

class Storify: NSObject {
    static let shared = Storify()
    
}
