//
//  Notify.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

struct NotifName {
    static let authLogin = Notification.Name("auth_login")
    static let authLogout = Notification.Name("auth_logout")
    
    static let getProducts = Notification.Name("get_products")
    
    static let getUserProfile = Notification.Name("get_user_profile")
    
    static let newNotificationAvailable = Notification.Name("new_notification_available")
}

class Notify: NSObject {
    static let shared = Notify()
    
    // Instance var
    fileprivate var listener = [NSObject]()
    
    // MARK: - Static Method
    static func post(name: Notification.Name, sender: NSObject? = nil, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: (sender == nil ? self : sender), userInfo: userInfo)
    }
    
    // MARK: - Public Methods
    func listen(_ sender: NSObject, selector: Selector, name: Notification.Name? = nil, object: Any? = nil) {
        NotificationCenter.default.addObserver(sender, selector: selector, name: name, object: object)
        listener.append(sender)
    }
    
    func removeListener(_ listener: NSObject, name: Notification.Name? = nil, object: Any? = nil) {
        if let index = self.listener.firstIndex(where: {$0 == listener}) {
            self.listener.remove(at: index)
            NotificationCenter.default.removeObserver(listener, name: name, object: object)
        }
    }
    
    func removeAllListener() {
        let nCenter = NotificationCenter.default
        for anObject in listener {
            nCenter.removeObserver(anObject)
        }
        listener.removeAll()
    }
}
