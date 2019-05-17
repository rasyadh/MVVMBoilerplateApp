//
//  Storify.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    // User
    var user: User!
    
    // MARK: Authentications
    func handleSuccessfullLogin(_ data: JSON, _ meta: JSON) {
        setUserDefaultInformation(meta)
        storeUserData(data)
        Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": true])
    }
    
    func handleSuccessfullLogout(_ data: JSON) {
        let pref = UserDefaults.standard
        pref.set(false, forKey: Preferences.isLoggedIn)
        pref.removeObject(forKey: Preferences.tokenLogin)
        pref.removeObject(forKey: Preferences.userData)
        removeData()
        Notify.post(name: NotifName.authLogout, sender: self, userInfo: ["success": true])
    }
    
    func handleRefreshToken(_ data: JSON) {
        setUserDefaultInformation(data)
    }
    
    private func setUserDefaultInformation(_ meta: JSON) {
        let token = meta["token"].stringValue
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.set(token, forKey: Preferences.tokenLogin)
    }
    
    private func storeUserData(_ data: JSON) {
        user = User(data)
        let pref = UserDefaults.standard
        pref.set([
            "id": user.id,
            "email": user.email,
            "name": user.name
        ], forKey: Preferences.userData)
    }
    
    func logoutUser() {
        let pref = UserDefaults.standard
        pref.set(false, forKey: Preferences.isLoggedIn)
        pref.removeObject(forKey: Preferences.tokenLogin)
        pref.removeObject(forKey: Preferences.userData)
        removeData()
    }
    
    private func removeData() {
        user = nil
    }
    
    // MARK: - User
    func storeUserProfile(_ data: JSON) {
        user = User(data)
        Notify.post(name: NotifName.getUserProfile, sender: self, userInfo: ["success": true])
    }
    
    // MARK: - Products
    func storeProducts(_ data: JSON) {
        Notify.post(name: NotifName.getProducts, sender: self ,userInfo: ["success": true])
    }
}
