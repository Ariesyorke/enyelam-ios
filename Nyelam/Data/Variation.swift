//
//  Variation.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Variation: NSObject, NSCoding, Parseable {
    
    var key: String?
    var variationItems: [VariationItem]?
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }
    
    override init() {
        super.init()
    }

    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        if let key = self.key, !key.isEmpty {
            if let array = json[key] as? Array<[String: Any]> {
                for obj in array {
                    if self.variationItems == nil {
                        self.variationItems = []
                    }
                    let item = VariationItem(json: obj)
                    self.variationItems?.append(item)
                }
            }
        } else {
            for (key, value) in json {
                self.key = key
                if let array = value as? Array<[String: Any]> {
                    for obj in array {
                        if self.variationItems == nil {
                            self.variationItems = []
                        }
                        var q: Int = 0
                        if let qty = obj["qty"] as? Int {
                            q = qty
                        } else if let qty = obj["qty"] as? String, qty.isNumber {
                            q = Int(qty)!
                        }
                        if q <= 0 {
                            continue
                        }
                        let item = VariationItem(json: obj)
                        self.variationItems?.append(item)
                    }
                }
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let key = self.key, let variationItems = self.variationItems, !variationItems.isEmpty {
            var array: Array<[String: Any]> = []
            for item in variationItems {
                array.append(item.serialized())
            }
            json[key] = array
        }
        return json
    }
    
}
