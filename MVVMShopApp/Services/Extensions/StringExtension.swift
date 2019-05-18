//
//  StringExtension.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func toDate(format: String = "") -> Date? {
        _ = TimeZone.current.secondsFromGMT(for: Date.init(timeIntervalSinceNow: 3600*24*60)) / 3600
        
        var stringDate = ""
        let dateFormatter = DateFormatter()
        // dateFormatter.locale = Locale(identifier: "id_ID")
        
        if format == "" {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            stringDate = self
        }
        else if format == "yyyy-MM-dd HH:mm" {
            dateFormatter.dateFormat = format
            let index = self.index(self.startIndex, offsetBy: format.count)
            stringDate = String(self[..<index])
        }
        else if format == "yyyy-MM-dd'T'HH:mm:ss.SSSZ" {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            stringDate = self
        }
        else if format == "yyyy-MM-dd" {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            stringDate = self
        }
        else {
            dateFormatter.dateFormat = format
            stringDate = self
        }
        
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }
        else {
            return nil
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegexString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegexString)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func UTCToLocal(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    func convertStringToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: AnyObject]
            }
            catch let error as NSError {
                print("error: \(error)")
            }
        }
        return nil
    }
}

extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
