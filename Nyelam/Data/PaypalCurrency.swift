//
//  PaypalCurrency.swift
//  Nyelam
//
//  Created by Bobi on 5/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class PaypalCurrency: NSObject, Parseable {
    private let KEY_CURRENCY = "currency"
    private let KEY_AMOUNT = "amount"
    
    var currency: String?
    var amount: Double = 0
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.currency = json[KEY_CURRENCY] as? String
        if let amount = json[KEY_AMOUNT] as? Double {
            self.amount = amount
        } else if let amount = json[KEY_AMOUNT] as? String {
            if amount.isNumber {
                self.amount = Double(amount)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let currency = self.currency {
            json[KEY_CURRENCY] = currency
        }
        json[KEY_AMOUNT] = amount
        return json
    }
}
