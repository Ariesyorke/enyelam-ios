//
//  Size.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Size: NSObject, Parseable, NSCoding {
    private let KEY_SIZE = "size"
    private let KEY_QTY = "qty"
    
    var qty: Int = 0
    var size: String?
    
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
        if let qty = json["qty"] as? Int {
            self.qty = qty
        } else if let qty = json["qty"] as? String {
            if qty.isNumber {
                self.qty = Int(qty)!
            }
        }
        self.size = json["size"] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json["qty"] = qty
        if let size = self.size, !size.isEmpty {
            json["size"] = size
        }
        return json
    }
}
