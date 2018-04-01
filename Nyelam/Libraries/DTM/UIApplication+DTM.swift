//
//  UIApplication+DTM.swift
//  Googaga
//
//  Created by Ramdhany Dwi Nugroho on 11/7/16.
//  Copyright © 2016 Dantech. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    func findAvailableControllerToPresentController(currentController: UIViewController?) -> UIViewController! {
        
        var controller: UIViewController? = currentController
        if controller == nil {
            controller = self.getTopMostController(currentController: self.keyWindow!.rootViewController!)
        }
        
        let presentedController: UIViewController? = controller!.presentedViewController
        
        if presentedController != nil {
            return self.findAvailableControllerToPresentController(currentController: presentedController!)
        } else if presentedController != nil && controller!.isKind(of: UIAlertController.self) {
            return self.findAvailableControllerToPresentController(currentController: presentedController!)
        } else {
            return controller
        }
    }
    
    func getTopMostController(currentController: UIViewController?) -> UIViewController {
        var controller: UIViewController? = currentController
        if controller == nil {
            controller = self.getTopMostController(currentController: self.keyWindow!.rootViewController!)
        }
        
        let presentedController: UIViewController? = controller!.presentedViewController
        
        if presentedController != nil {
            return self.getTopMostController(currentController: presentedController!)
        } else {
            if controller!.isKind(of: UINavigationController.self) {
                let cs: [UIViewController] = (controller as! UINavigationController).viewControllers
                return cs[cs.count - 1]
            } else if controller!.isKind(of: UITabBarController.self) {
                let tab: UITabBarController = controller as! UITabBarController
                if tab.viewControllers != nil {
                    return tab.viewControllers![tab.selectedIndex]
                } else {
                    return tab
                }
            } else {
                return controller!
            }
        }
    }
}
