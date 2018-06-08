//
//  NConstant.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import MidtransCoreKit

class NConstant {
    static var appVersion: String {
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject?
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
        return .production
    }
    
    static var GOOGLE_CLIENT_ID: String {
        return "359054383364-qu2ipqnfu6ues5r6bllc5cbk98rlre80.apps.googleusercontent.com"
    }
    
    static var GOOGLE_API_KEY: String {
        return "AIzaSyBjzn1Acfbp8tWG6XpoGviDE-xOlU5doXM"
    }
    
    static var PAYPAL_CLIENT_ID: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "AZpSKWx_d3bY8qO23Rr7hUbd5uUappmzGliQ1A2W5VWz4DVP011eNGN9k5NKu_sLhKFFQPvp5qgF4ptJ"
        default:
            return "AesXhJkhDyCXfFEiuR31DCeLPH4UqHB6nNTrjpvOmgh2VfRYzJTX-Cfq8X4h2GVvyyBoc81rXm8D8-1Z"
        }
    }
    
    static var PAYPAL_ENVIRONTMENT: String {
        switch NConstant.URL_TYPE {
        case .production:
            return PayPalEnvironmentProduction
        default:
            return PayPalEnvironmentSandbox
        }
    }
    
    static var MIDTRANS_CLIENT_ID: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "Mid-client-LmqmZSunNywXQf-f"
        default:
            return "SB-Mid-client-_2uec0T1LQec4odt"
        }
    }
    
    static var MIDTRANS_URL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "https://api.veritrans.co.id/v2"
        default:
            return "https://api.sandbox.midtrans.com/v2"
        }
    }
    
    static var MIDTRANS_ENVIRONTMENT: MidtransServerEnvironment {
        switch NConstant.URL_TYPE {
        case .production:
            return .production
        default:
            return .sandbox
        }
    }
    
    static var paypalEnvironment: String {
        switch NConstant.URL_TYPE {
        case .production:
            return self.paypalProductionEnvironment
        default:
            return self.paypalDevelopmentEnvironment
        }
    }
    
    static var paypalDevelopmentEnvironment: String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != paypalDevelopmentEnvironment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    static var paypalProductionEnvironment:String = PayPalEnvironmentProduction {
        willSet(newEnvironment) {
            if (newEnvironment != paypalProductionEnvironment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }

}

