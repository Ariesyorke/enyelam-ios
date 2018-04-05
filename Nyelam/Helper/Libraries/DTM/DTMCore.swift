//
//  DTMCore.swift
//  Dev_Apple
//
//  Created by Ramdhany Dwi Nugroho on 5/19/16.
//  Copyright © 2016 Dev_Apple. All rights reserved.
//

import Foundation
import UIKit

class DTMLog {
    static let DEBUG_FLAG: Bool! = true
    
    class func debug(items: Any...) {
        if DEBUG_FLAG! {
            debugPrint(items)
        }
    }
    
    class func fatalError(items: Any...) {
        debugPrint(items)
    }
}


class DTMHelper {
//    class func attributingString(string: String!, font: UIFont!) -> NSAttributedString! {
//        let attrStr = try! NSMutableAttributedString(
//            data: string.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
//            options: [
//                NSAttributedString.DocumentReadingOptionKey: NSAttributedString.DocumentType.html
//            ],
//            documentAttributes: nil)
//        attrStr.setAttributes([NSFontAttributeName: font], range: NSMakeRange(0, attrStr.length))
//        return attrStr
//    }
    
    class func findFirstResponder(rootView: UIView!) -> UIView? {
        if rootView.isFirstResponder {
            return rootView
        }
        
        for view: UIView in rootView.subviews {
            let t: UIView? = DTMHelper.findFirstResponder(rootView: view)
            if t != nil {
                return t
            }
        }
        
        return nil
    }
    
    class func addShadow(_ view: UIView, color: UIColor, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
    }
    
    class func addShadow(_ view: UIView, color: UIColor, radius: CGFloat) {
        addShadow(view, color: color, radius: radius, offset: CGSize(width: 0, height: 2.5))
    }
    
    class func addShadow(_ view: UIView, color: UIColor) {
        addShadow(view, color: color, radius: 2.5, offset: CGSize(width: 0, height: 2.5))
    }
    
    class func addShadow(_ view: UIView) {
        addShadow(view, color: UIColor.lightGray, radius: 2.5, offset: CGSize(width: 0, height: 2.5))
    }
}

class DeviceIDGenerator: NSObject {
    private var fireHandler: (DeviceIDGenerator) -> Void! = {waiters in return}
    
    class func generateDeviceId(complete: @escaping (String!) -> Void) {
        let rawUUID: NSUUID? = UIDevice.current.identifierForVendor as NSUUID?
        if rawUUID == nil {
            let waiters: DeviceIDGenerator = DeviceIDGenerator()
            waiters.waitForIt(timeInSecond: 5.0, fireHandler: { waiters in
                DeviceIDGenerator.generateDeviceId(complete: complete)
            })
        } else {
            complete(rawUUID!.uuidString)
        }
    }
    
    func waitForIt(timeInSecond: TimeInterval, fireHandler: @escaping (DeviceIDGenerator) -> Void!) {
        self.fireHandler = fireHandler
        Timer.scheduledTimer(timeInterval: timeInSecond, target: self, selector: #selector(DeviceIDGenerator.fire), userInfo: nil, repeats: false)
    }
    
    @objc func fire() {
        self.fireHandler(self)
    }
}

