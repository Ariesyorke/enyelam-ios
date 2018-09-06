//
//  Cart.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Cart: NSObject, NSCoding, Parseable {
    private let KEY_SUBTOTAL = "sub_total"
    private let KEY_TOTAL = "total"
    private let KEY_CURRENCY = "currency"
    private let KEY_VOUCHER = "voucher"
    
    var subtotal: Double = 0
    var total: Double = 0
    var currency: String?
    var voucher: Voucher?
    
    override init(){}
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
        if let voucherJson = json[KEY_VOUCHER] as? [String: Any] {
            self.voucher = Voucher(json: voucherJson)
        } else if let voucherString = json[KEY_VOUCHER] as? String {
            do {
                let data = voucherString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let voucherJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.voucher = Voucher(json: voucherJson)
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_SUBTOTAL] = subtotal
        json[KEY_TOTAL] = total
        if let currency = json[KEY_CURRENCY] as? String {
            json[KEY_CURRENCY] = currency
        }
        if let voucher = self.voucher {
            json[KEY_VOUCHER] = voucher.serialized()
        }
        return json
    }
}
