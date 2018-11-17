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


    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        for (key, value) in json {
            self.key = key
            if let array = value as? Array<[String: Any]> {
                for obj in array {
                    if self.variationItems == nil {
                        self.variationItems = []
                    }
                    let item = VariationItem(json: obj)
                    self.variationItems?.append(item)
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
