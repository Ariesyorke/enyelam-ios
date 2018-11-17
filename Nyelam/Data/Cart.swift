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
    private let KEY_MERCHANTS = "merchants"
    private let KEY_ADDITONALS = "additionals"
    
    var subtotal: Double = 0
    var total: Double = 0
    var currency: String?
    var voucher: Voucher?
    var additionals: [Additional]?
    var merchants: [Merchant]?
    
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
        if let merchantArray = json[KEY_MERCHANTS] as? Array<[String: Any]>, !merchantArray.isEmpty {
            self.merchants = []
            for merchantJson in merchantArray {
                let merchant = Merchant(json: merchantJson)
                self.merchants!.append(merchant)
            }
        } else if let merchantArrayString = json[KEY_MERCHANTS] as? String {
            do {
                let data = merchantArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let merchantArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.merchants = []
                self.merchants = []
                for merchantJson in merchantArray {
                    let merchant = Merchant(json: merchantJson)
                    self.merchants!.append(merchant)
                }
            } catch {
                print(error)
            }
        }
        
        if let additionalArray = json[KEY_ADDITONALS] as? Array<[String: Any]> {
            self.additionals = []
            for additionalJson in additionalArray {
                let additional = Additional(json: additionalJson)
                self.additionals?.append(additional)
            }
        } else if let additionalString = json[KEY_ADDITONALS] as? String {
            do {
                let data = additionalString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let additionalArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.additionals = []
                for additionalJson in additionalArray {
                    let additional = Additional(json: additionalJson)
                    self.additionals!.append(additional)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_SUBTOTAL] = subtotal
        json[KEY_TOTAL] = total
        if let merchants = self.merchants, !merchants.isEmpty {
            var array: Array<[String: Any]> = []
            for merchant in merchants {
                array.append(merchant.serialized())
            }
            json[KEY_MERCHANTS] = array
        }
        if let currency = json[KEY_CURRENCY] as? String {
            json[KEY_CURRENCY] = currency
        }
        if let voucher = self.voucher {
            json[KEY_VOUCHER] = voucher.serialized()
        }
        if let additionals = self.additionals, !additionals.isEmpty {
            var additionalArray: Array<[String: Any]> = []
            for additional in additionals {
                additionalArray.append(additional.serialized())
            }
            json[KEY_ADDITONALS] = additionalArray
        }

        return json
    }
}
