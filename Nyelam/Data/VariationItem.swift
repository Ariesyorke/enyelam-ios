//
//  Variation.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class VariationItem: Parseable {
    fileprivate let KEY_ID = "id"
    fileprivate let KEY_NAME = "name"
    fileprivate let KEY_QTY = "qty"
    fileprivate let KEY_NORMAL_PRICE = "normal_price"
    fileprivate let KEY_SPECIAL_PRICE = "special_price"
    fileprivate let KEY_PICKED  = "picked"
    
    var id: String?
    var name: String?
    var qty: Int = 0
    var normalPrice: Double = 0.0
    var specialPrice: Double = 0.0
    var picked: Bool = false
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        if let qty = json[KEY_QTY] as? Int {
            self.qty = qty
        } else if let qty = json[KEY_QTY] as? String {
            if qty.isNumber {
                self.qty = Int(qty)!
            }
        }
        if let normalPrice = json[KEY_NORMAL_PRICE] as? Double {
            self.normalPrice = normalPrice
        } else if let normalPrice = json[KEY_NORMAL_PRICE] as? String {
            if normalPrice.isNumber {
                self.normalPrice = Double(normalPrice)!
            }
        }
        if let specialPrice = json[KEY_SPECIAL_PRICE] as? Double {
            self.specialPrice = specialPrice
        } else if let specialPrice = json[KEY_SPECIAL_PRICE] as? String {
            if specialPrice.isNumber {
                self.specialPrice = Double(specialPrice)!
            }
        }
        if let picked = json[KEY_PICKED] as? Bool {
            self.picked = picked
        }
     }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        json[KEY_QTY] = self.qty
        json[KEY_NORMAL_PRICE] = self.normalPrice
        json[KEY_SPECIAL_PRICE] = self.specialPrice
        json[KEY_PICKED] = self.picked
        
        return json
    }
}
