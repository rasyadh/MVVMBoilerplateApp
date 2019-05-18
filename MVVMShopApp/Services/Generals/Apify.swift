//
//  Apify.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

enum RequestCode {
    case authLogin,
    authLogout,
    
    getProducts,
    getUserProfile
}

class Apify: NSObject {
    static let shared = Apify()
    var prevOperationData: [String: Any]?
    
    let API_BASE_URL = "http://127.0.0.1/api"
    
    let API_AUTH_LOGIN = "/login"
    let API_AUTH_LOGOUT = "/logout"
    
    let API_PRODUCTS = "/products"
    let API_USERS = "/users"
    
    // MARK: - Basic functions
    fileprivate func getHeaders(withAuthorization: Bool, withXApiKey: Bool, accept: String? = nil) -> [String: String] {
        var headers = [String: String]()
        
        // Assign accept properties
        if accept == nil { headers["Accept"] = "application/json" }
        else { headers["Accept"] = accept }
        
        // Assign x-api-key properties
        if withXApiKey {
            headers["x-api-key"] = "X_API_KEY_SECRET"
        }
        
        // Asign authorization properties
        if withAuthorization {
            if let token = UserDefaults.standard.string(forKey: Preferences.tokenLogin) {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        return headers
    }
    
    private func setRequestData(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) -> [String: Any] {
        // Save request data in case if request is failed due to expired token
        var requestData = [
            "url": url,
            "method": method,
            "code": code
            ] as [String: Any]
        
        if parameters != nil { requestData["parameters"] = parameters }
        if headers != nil { requestData["headers"] = headers }
        
        return requestData
    }
    
    // Async Request
    private func request(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) {
        let _ = setRequestData(url, method: method, parameters: parameters, headers: headers, code: code)
        
        // Perform request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                print(response)
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if var json = JSON(rawValue: response.data as Any) {
                        if json["message"].stringValue == "Unauthenticated." {
                            json["expired"] = true
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json": json])
                        }
                        print("[ ERROR ] Error JSON : \(json)")
                        self.consolidation(code, success: false, additionalData: ["json": json])
                        return
                    }
                    else {
                        self.consolidation(code, success: false)
                        return
                    }
                }
        }
    }
    
    private func requestAnyParam(_ url: String, method: HTTPMethod, parameters: [String: Any]?, headers: [String: String]?, code: RequestCode) {
        // Perform request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                print(response)
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if var json = JSON(rawValue: response.data as Any) {
                        if json["message"].stringValue == "Unauthenticated." {
                            json["expired"] = true
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json": json])
                        }
                        print("[ ERROR ] Error JSON : \(json)")
                        self.consolidation(code, success: false, additionalData: ["json": json])
                        return
                    }
                    else {
                        self.consolidation(code, success: false)
                        return
                    }
                }
        }
    }
    
    // Sync Request
    private func requestSync(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, completion: @escaping(_ data: JSON) -> Void) {
        // Perform Request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                // URL parsing or pre-delivery functions goes here
                print("[ SUCCESS ] : Request Synchronous")
                print("[ Success ] Status Code: \(response.response!.statusCode)")
                let responseJSON = try! JSON(data: response.data!)
                completion(responseJSON["data"])
            case .failure:
                // Request error parsing
                print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                print("[ ERROR ] : Result : %@", response.result.value as Any)
                completion(["success": false])
            }
        }
    }
    
    // Async Multipart Form Request
    private func uploadRequest(_ url: String, method: HTTPMethod, parameters: [String: String]?, imageParameters: [String: Any]?, headers: [String: String]?, code: RequestCode) {
        // perform multipart request
        upload(multipartFormData: { multipartFormData in
            if let imageParameters = imageParameters {
                guard let imageParam = imageParameters["image"] else { return }
                guard let imageName = imageParameters["name"] else { return }
                guard let imageFieldName = imageParameters["field_name"] else { return }
                
                if let imageSize = (imageParam as! UIImage).jpegData(compressionQuality: 1)?.count {
                    var imageData: Data?
                    if Double(imageSize) / 1024 > 7168.0 {
                        imageData = (imageParam as! UIImage).compressImage(.lowest)
                    }
                    else if Double(imageSize) / 1024 < 7168.0 && Double(imageSize) / 1024 > 5120.0 {
                        imageData = (imageParam as! UIImage).compressImage(.low)
                    }
                    else if Double(imageSize) / 1024 < 5120.0 && Double(imageSize) / 1024 > 3072.0 {
                        imageData = (imageParam as! UIImage).compressImage(.medium)
                    }
                    else if Double(imageSize) / 1024 < 3072.0 && Double(imageSize) / 1024 > 1024.0 {
                        imageData = (imageParam as! UIImage).compressImage(.high)
                    }
                    else if Double(imageSize) / 1024 < 1024.0 && Double(imageSize) / 1024 > 0.0 {
                        imageData = (imageParam as! UIImage).compressImage(.highest)
                    }
                    
                    let imageName = "\(String(describing: imageName)).jpg"
                    multipartFormData.append(imageData!, withName: imageFieldName as! String, fileName: imageName, mimeType: "image/jpeg")
                }
            }
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url, method: method, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response)
                    
                    switch response.result {
                    case .success:
                        print("[ SUCCESS ] Request Code : \(code)")
                        
                        // URL parsing or pre-delivery functions goes here
                        let responseJSON = try! JSON(data: response.data!)
                        
                        if !responseJSON["errors"].dictionaryValue.isEmpty {
                            self.consolidation(code, success: false, additionalData: ["json": JSON(rawValue: response.data as Any)!])
                        }
                        else {
                            var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                            
                            if !responseJSON["meta"].isEmpty {
                                addData!["meta"] = responseJSON["meta"]
                            }
                            
                            self.consolidation(code, success: true, additionalData: addData)
                        }
                    case .failure:
                        print("[ Failed ] Request Code : \(code)")
                        print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                        print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                        print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                        print("[ ERROR ] : Result : %@", response.result.value as Any)
                        
                        // Request Error Handling here
                        if let json = JSON.init(rawValue: response.data as Any) {
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json" : json])
                        }else {
                            self.consolidation(code, success: false)
                        }
                    }
                }
            case .failure(let encodingError):
                print("[ Error ] create request or preorder error : \(encodingError)")
                self.consolidation(code, success: false)
            }
        })
    }
    
    private func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: [String: Any]? = nil) {
        var dict = [String: Any]()
        dict["success"] = success
        
        if additionalData != nil {
            for (key, value) in additionalData! {
                dict[key] = value
            }
            
            if !success && dict["json"] != nil {
                if let json = dict["json"] as? JSON {
                    if let error = json["error"].string {
                        dict["error"] = error
                    }
                    
                    if let message = json["message"].string {
                        dict["message"] = message
                    }
                    
                    if let expired = json["expired"].bool {
                        dict["expired"] = expired
                    }
                }
            }
        }
        
        switch requestCode {
        // Authentication
        case .authLogin:
            if success { Storify.shared.handleSuccessfullLogin(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.authLogin, sender: self, userInfo: dict) }
        case .authLogout:
            if success { Storify.shared.handleSuccessfullLogout(dict["json"] as! JSON) }
            else { Notify.post(name: NotifName.authLogout, sender: self, userInfo: dict) }
            
        // User
        case .getUserProfile:
            if success { Storify.shared.storeUserProfile(dict["json"] as! JSON) }
            else { Notify.post(name: NotifName.getUserProfile, sender: self, userInfo: dict) }
            
        // Products
        case .getProducts:
            if success { Storify.shared.storeProducts(dict["json"] as! JSON) }
            else { Notify.post(name: NotifName.getProducts, sender: self, userInfo: dict) }
        }
    }
    
    func reRequestData(data: [String: Any]?) {
        var requestHeaders = [String: String]()
        if let headers = data!["headers"] as? [String: String] {
            requestHeaders = headers
            for (key, value) in getHeaders(withAuthorization: true, withXApiKey: false) {
                requestHeaders[key] = value
            }
        }
        
        request(
            data!["url"] as! String,
            method: data!["method"] as! HTTPMethod,
            parameters: data!["parameters"] as? [String: String],
            headers: requestHeaders,
            code: data!["code"] as! RequestCode)
    }
    
    // MARK: - Auth
    func login(parameters: [String: String]) {
        let URL = API_BASE_URL + API_AUTH_LOGIN
        
        request(
            URL,
            method: .post,
            parameters: parameters,
            headers: getHeaders(withAuthorization: false, withXApiKey: true),
            code: .authLogin)
    }
    
    func logout() {
        let URL = API_BASE_URL + API_AUTH_LOGOUT
        
        request(
            URL,
            method: .post,
            parameters: nil,
            headers: getHeaders(withAuthorization: true, withXApiKey: false),
            code: .authLogout)
    }
    
    // MARK: - User
    func getUserProfile() {
        let URL = API_BASE_URL + API_USERS + "/profile"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(withAuthorization: true, withXApiKey: false),
            code: .getUserProfile)
    }
    
    // MARK: - Products
    func getProducts() {
        let URL = API_BASE_URL + API_PRODUCTS
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(withAuthorization: true, withXApiKey: false),
            code: .getProducts)
    }
}
