//
//  Additional.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Additional: NSObject, NSCoding, Parseable {
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }
    
    private let KEY_TITLE = "title"
    private let KEY_VALUE = "value"
    
    var title: String?
    var value: Double?
    
    override init(){}
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
        
    func parse(json: [String: Any]) {
        self.title = json[KEY_TITLE] as? String
        if let value = json[KEY_VALUE] as? Double {
            self.value = value
        } else if let value = json[KEY_VALUE] as? String {
            if value.isNumber {
                self.value = Double(value)
            }
        }
    }
    
    func serialized() -> [String: Any] {
        var json: [String: Any] = [:]
        
        if let title = self.title {
            json[KEY_TITLE] = title
        }
        if let value = self.value {
            json[KEY_VALUE] = value
        }
        return json
    }
    
}
