//
//  Price.swift
//  Nyelam
//
//  Created by Bobi on 4/20/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class Price: NSObject, Parseable {
    private let KEY_LOWEST_PRICE = "lowest_price"
    private let KEY_HIGHEST_PRICE = "highest_price"
    
    var lowestPrice: Int = 0
    var highestPrice: Int = 0
    
    func parse(json: [String : Any]) {
        if let lowestPrice = json[KEY_LOWEST_PRICE] as? Int {
            self.lowestPrice = lowestPrice
        } else if let lowestPrice = json[KEY_LOWEST_PRICE] as? String {
            self.lowestPrice = Int(lowestPrice)!
        }
        if let highestPrice = json[KEY_HIGHEST_PRICE] as? Int {
            self.highestPrice = highestPrice
        } else if let highestPrice = json[KEY_HIGHEST_PRICE] as? String {
            self.highestPrice = Int(highestPrice)!
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_LOWEST_PRICE] = self.lowestPrice
        json[KEY_HIGHEST_PRICE] = self.highestPrice
        return json
    }
}
