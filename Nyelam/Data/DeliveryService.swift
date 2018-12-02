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
    private let KEY_TRACKING_ID = "tracking_id"
    var id: String?
    var name: String?
    var price: Double = 0
    var trackingId: String?
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        self.trackingId = json[KEY_TRACKING_ID] as? String
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
        if let trackingId = self.trackingId {
            json[KEY_TRACKING_ID] = trackingId
        }
        json[KEY_PRICE] = price
        return json
    }
}
