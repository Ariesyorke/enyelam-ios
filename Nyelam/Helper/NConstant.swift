//
//  NConstant.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NConstant {
    static var appVersion: String {
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        return nsObject as! String
    }
    
    static var ecotripStatic: [String: Any] {
        return ["id":"23","name":"Save Our Small Island", "type":3]
    }
    
    static var deviceModel: String {
        return "Apple/ \(UIDevice.current.model)"
    }
    
    static var currentTimeStamp: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var URL_TYPE: NURLType {
        return .development
    }
    
    static var GOOGLE_CLIENT_ID: String {
        return "359054383364-qu2ipqnfu6ues5r6bllc5cbk98rlre80.apps.googleusercontent.com"
    }
}

