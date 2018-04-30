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
    
    var lowestPrice: CGFloat = 0
    var highestPrice: CGFloat = 0
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    init(lowestPrice: CGFloat, highestPrice: CGFloat) {
        super.init()
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
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
        if let lowestPrice = json[KEY_LOWEST_PRICE] as? Double {
            self.lowestPrice = CGFloat(lowestPrice)
        } else if let lowestPrice = json[KEY_LOWEST_PRICE] as? String {
            if lowestPrice.isNumber {
                self.lowestPrice = CGFloat(Double(lowestPrice)!)
            }
        }
        if let highestPrice = json[KEY_HIGHEST_PRICE] as? Double {
            self.highestPrice = CGFloat(highestPrice)
        } else if let highestPrice = json[KEY_HIGHEST_PRICE] as? String {
            if highestPrice.isNumber {
                self.highestPrice = CGFloat(Double(highestPrice)!)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_LOWEST_PRICE] = self.lowestPrice
        json[KEY_HIGHEST_PRICE] = self.highestPrice
        return json
    }
}
