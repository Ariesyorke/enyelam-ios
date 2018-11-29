//
//  CourierCost.swift
//  Nyelam
//
//  Created by Bobi on 11/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class CourierCost: Parseable {
    private let KEY_VALUE = "value"
    private let KEY_ETD = "etd"
    private let KEY_NOTE = "note"
    
    var value: Int64 = 0
    var etd: String?
    var note: String?
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        if let value = json[KEY_VALUE] as? Double {
            self.value = Int64(value)
        } else if let value = json[KEY_VALUE] as? String {
            if value.isNumber {
                self.value = Int64(value)!
            }
        }
        self.etd = json[KEY_ETD] as? String
        self.note = json[KEY_NOTE] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_VALUE] = Double(value)
        if let etd = self.etd, !etd.isEmpty {
            json[KEY_ETD] = etd
        }
        if let note = self.note, !note.isEmpty {
            json[KEY_NOTE] = note
        }
        return json
    }

}
