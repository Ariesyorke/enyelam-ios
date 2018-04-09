//
//  UIColor+Nyelam.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var primary: UIColor {
        return primary(1.0)
    }
    
    static func primary(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 22/255, green: 117/255, blue: 207/255, alpha: alpha)
    }
    
    static var primaryDark: UIColor {
        return primary(1.0)
    }
    
    static func primaryDark(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 22/255, green: 117/255, blue: 207/255, alpha: alpha)
    }
    
    static var accent: UIColor {
        return accent(1.0)
    }
    
    static var blueActive: UIColor {
        return UIColor(red: 0, green: 169/255, blue: 231/255, alpha: 1.0)
    }
    
    static var yellowActive: UIColor {
        return UIColor(red: 222/255, green: 229/255, blue: 37/255, alpha: 1.0)
    }
    
    static var nyOrange: UIColor {
        return UIColor(red: 1, green: 152/255, blue: 18/255, alpha: 1.0)
    }
    
    static func accent(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 1, green: 64/255, blue: 129/255, alpha: alpha)
    }
    
    static var primaryGradationLeft: UIColor {
        return UIColor(red: 37/255, green: 162/255, blue: 219/255, alpha: 1.0)
    }
    
    static var primaryGradationRight: UIColor {
        return UIColor(red: 27/255, green: 118/255, blue: 187/255, alpha: 1.0)
    }
    
    static var primaryGradationMenuLeft: UIColor {
        return UIColor(red: 35/255, green: 155/255, blue: 214/255, alpha: 1.0)
    }
    
    static var primaryGradationMenuRight: UIColor {
        return UIColor(red: 27/255, green: 118/255, blue: 187/255, alpha: 1.0)
    }
    
    static var primaryGradationSoftLeft: UIColor {
        return UIColor(red: 102/255, green: 189/255, blue: 229/255, alpha: 1.0)
    }
    
    static var primaryGradationSoftRight: UIColor {
        return UIColor(red: 96/255, green: 160/255, blue: 208/255, alpha: 1.0)
    }
    
    static var primaryTabMenuLeft: UIColor {
        return UIColor(red: 0, green: 125/255, blue: 196/255, alpha: 1.0)
    }
    
    static var primaryTabMenuRight: UIColor {
        return UIColor(red: 0, green: 169/255, blue: 226/255, alpha: 1.0)
    }
}
