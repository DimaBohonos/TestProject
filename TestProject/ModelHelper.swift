//
//  ModelHelper.swift

import UIKit

class ModelHelper {
    
    fileprivate static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    static func dateFromString(_ dateString: String?) -> Date? {
        guard dateString != nil else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")//Constants.localeIdentifier)
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: dateString!)
        return date
    }
    
    static func boolFromInt(_ intValue: Int?) -> Bool? {
        guard intValue != nil else {
            return nil
        }
        
        if intValue! == 1 {
            return true
        }
        return false
    }
}
