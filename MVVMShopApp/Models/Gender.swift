//
//  Gender.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Gender {
    var id: Int = 0
    var name: String = ""
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].intValue
        self.name = data["name"].stringValue
    }
}
