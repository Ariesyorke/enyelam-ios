//
//  PaypalCurrency.swift
//  Nyelam
//
//  Created by Bobi on 5/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class PaypalCurrency: NSObject, NSCoding, Parseable {
    private let KEY_CURRENCY = "currency"
    private let KEY_AMOUNT = "amount"
    
    var currency: String?
    var amount: Double = 0
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
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
