//
//  UIViewController+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 06/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func delay(_ delay: Double, closure: @escaping (_ object: Any) -> (), obj: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure(obj)
        }
    }
}

