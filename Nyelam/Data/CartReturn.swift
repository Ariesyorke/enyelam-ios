//
//  CartReturn.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class CartReturn: NSObject, NSCoding, Parseable {
    private let KEY_CART_TOKEN = "cart_token"
    private let KEY_EXPIRY = "expiry"
    private let KEY_CART = "cart"
    private let KEY_ADDITIONAL = "additional"
    
    var cartToken: String?
    var expiry: Double = 0
    var cart: Cart?
    var additionals: [Additional]?

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
        self.cartToken = json[KEY_CART_TOKEN] as? String
        if let expiry = json[KEY_EXPIRY] as? Double {
            self.expiry = expiry
        } else if let expiry = json[KEY_EXPIRY] as? String {
            if expiry.isNumber {
                self.expiry = Double(expiry)!
            }
        }
        if let cartJson = json[KEY_CART] as? [String: Any] {
            self.cart = Cart(json: cartJson)
        } else if let cartString = json[KEY_CART] as? String {
            do {
                let data = cartString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let cartJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.cart = Cart(json: cartJson)
            } catch {
                print(error)
            }
        }
        
        if let additionalArray = json[KEY_ADDITIONAL] as? Array<[String: Any]> {
            self.additionals = []
            for additionalJson in additionalArray {
                let additional = Additional(json: additionalJson)
                self.additionals?.append(additional)
            }
        } else if let additionalString = json[KEY_ADDITIONAL] as? String {
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
        
        if let cartToken = self.cartToken {
            json[KEY_CART_TOKEN] = cartToken
        }
        
        json[KEY_EXPIRY] = self.expiry
        
        if let cart = self.cart {
            json[KEY_CART] = cart.serialized()
        }
        
        if let additionals = self.additionals, !additionals.isEmpty {
            var additionalArray: Array<[String: Any]> = []
            for additional in additionals {
                additionalArray.append(additional.serialized())
            }
            json[KEY_ADDITIONAL] = additionalArray
        }
        
        return json
    }
}
