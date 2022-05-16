//
//  Scalable.swift

import UIKit

struct Scalable {
    static var scale: CGFloat = {
        
        var screenWidth = 375.0
        
        let currentScreenWidth: CGFloat = UIScreen.main.bounds.width
        let value = currentScreenWidth / CGFloat(screenWidth)
        return value
    }()
    
    static func isIpad() -> Bool {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        return isIpad
    }
}
