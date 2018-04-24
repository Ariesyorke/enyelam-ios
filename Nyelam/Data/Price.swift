//
//  Price.swift
//  Nyelam
//
//  Created by Bobi on 4/20/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class Price: NSObject, NSCoding, Parseable {
    private let KEY_LOWEST_PRICE = "lowest_price"
    private let KEY_HIGHEST_PRICE = "highest_price"
    
    var lowestPrice: Int = 0
    var highestPrice: Int = 0
    
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
