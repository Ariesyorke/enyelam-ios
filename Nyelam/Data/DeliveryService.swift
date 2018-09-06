//
//  DeliveryService.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class DeliveryService: Parseable {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_PRICE = "price"
    
    var id: String?
    var name: String?
    var price: Double = 0
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        if let price = json[KEY_PRICE] as? Double {
            self.price = price
        } else if let price = json[KEY_PRICE] as? String {
            if price.isNumber {
                self.price = Double(price)!
            }
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
        json[KEY_PRICE] = price
        return json
    }
}
