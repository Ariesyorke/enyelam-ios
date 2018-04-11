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
    
    func circledView() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
