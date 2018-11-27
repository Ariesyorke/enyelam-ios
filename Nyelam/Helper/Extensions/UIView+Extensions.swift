//
//  UIView+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var circled: Bool {
        get {
            return false
        }
        set (newValue) {
            if newValue {
                self.circledView()
            } else {
                self.layer.cornerRadius = self.radius
                self.clipsToBounds = false
            }
        }
    }
    
    @IBInspectable var radius: CGFloat {
        get {
            return 0
        }
        set (newValue) {
            if (!self.circled) {
                self.layer.cornerRadius = newValue
            }
        }
    }
    
    func dropShadow(scale: Bool = true, widthOffset: CGFloat, heightOffset: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: widthOffset, height: heightOffset)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func halfCircledView() {
        self.layer.cornerRadius = (self.frame.size.width/2.5)
        self.clipsToBounds = true
    }
    
    func circledView() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
