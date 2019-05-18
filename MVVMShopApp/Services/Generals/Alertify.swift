//
//  Alertify.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

class Alertify: NSObject {
    static func displayAlert(title: String, message: String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localify.get("alertify.ok"), style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    static func confirmationDialog(title: String, message: String, confirmTitle: String, cancelTitle: String, sender: UIViewController, isDestructive: Bool = false, confirmCallback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        if isDestructive {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        }
        else {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        }
        sender.present(alert, animated: true, completion: nil)
    }
}
