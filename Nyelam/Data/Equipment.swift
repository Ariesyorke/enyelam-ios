//
//  Equipment.swift
//  Nyelam
//
//  Created by Bobi on 5/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit


class Equipment: NSObject, Parseable {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_NORMAL_PRICE = "normal_price"
    private let KEY_SPECIAL_PRICE = "special_price"
    private let KEY_AVAILABILITY_STOCK = "availability_stock"
    private let KEY_QUANTITY = "quantity"
    
    var id: String?
    var name: String?
    var normalPrice: Double = 0
    var specialPrice: Double = 0
    var availabilityStock: Int = 0
    var quantity: Int = 0
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
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
        
        if let stock = json[KEY_AVAILABILITY_STOCK] as? Int {
            self.availabilityStock = stock
        } else if let stock = json[KEY_AVAILABILITY_STOCK] as? String {
            if stock.isNumber {
                self.availabilityStock = Int(stock)!
            }
        }
        
        if let quantity = json[KEY_QUANTITY] as? Int {
            self.quantity = quantity
        } else if let quantity = json[KEY_QUANTITY] as? String {
            if quantity.isNumber {
                self.quantity = Int(quantity)!
            }
        }
    }
    
    func toJSONPost()->[String: Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }

        json[KEY_QUANTITY] = self.quantity
        return json
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        json[KEY_NORMAL_PRICE] = self.normalPrice
        json[KEY_SPECIAL_PRICE] = self.specialPrice
        json[KEY_AVAILABILITY_STOCK] = self.availabilityStock
        json[KEY_QUANTITY] = self.quantity
        
        return json
    }
}
