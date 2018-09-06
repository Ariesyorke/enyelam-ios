//
//  Voucher.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class Voucher: Parseable {
    private let KEY_CODE = "code"
    private let KEY_TYPE = "type"
    private let KEY_VALUE = "value"
    var code: String?
    var type: Int = -1
    var value: Double = 0
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.code = json[KEY_CODE] as? String
        if let type = json[KEY_TYPE] as? Int {
            self.type = type
        } else if let type = json[KEY_TYPE] as? String {
            if type.isNumber {
                self.type = Int(type)!
            }
        }
        if let value = json[KEY_VALUE] as? Double {
            self.value = value
        } else if let value = json[KEY_VALUE] as? String {
            if value.isNumber {
                self.value = Double(value)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let code = self.code {
            json[KEY_CODE] = code
        }
        json[KEY_TYPE] = self.type
        json[KEY_VALUE] = self.value
        return json
    }
}
