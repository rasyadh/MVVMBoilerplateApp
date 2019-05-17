//
//  Localify.swift
//  MVVMBoilerplateApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

enum LanguageName: String {
    // Add any language you want
    case english = "en"
}

class Localify: NSObject {
    static let shared = Localify()
    private var languageBundle: Bundle!
    var languageIdentifier = ""
    
    func setLanguage(_ name: LanguageName) {
        let path = Bundle.main.path(forResource: name.rawValue, ofType: ".lproj")!
        let bundle = Bundle(path: path)!
        languageBundle = bundle
        switch name {
        case .english:
            languageIdentifier = "en"
        }
    }
    
    static func get(_ key: String) -> String {
        return NSLocalizedString(key, bundle: Localify.shared.languageBundle, comment: "")
    }
}
