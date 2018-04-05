//
//  Cart.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Cart: NSObject, Parseable {
    private let KEY_SUBTOTAL = "sub_total"
    private let KEY_TOTAL = "total"
    private let KEY_CURRENCY = "currency"
    
    var subtotal: Double = 0
    var total: Double = 0
    var currency: String?
    
    override init(){}
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        if let subtotal = json[KEY_SUBTOTAL] as? Double {
            self.subtotal = subtotal
        } else if let subtotal = json[KEY_SUBTOTAL] as? String {
            if subtotal.isNumber {
                self.subtotal = Double(subtotal)!
            }
        }
        if let total = json[KEY_TOTAL] as? Double {
            self.total = total
        } else if let total = json[KEY_TOTAL] as? String {
            if total.isNumber {
                self.total = Double(total)!
            }
        }
        self.currency = json[KEY_CURRENCY] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        return json
    }
}
