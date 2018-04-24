//
//  Schedule.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Schedule: NSObject, NSCoding, Parseable {
    private let KEY_START_DATE = "start_date"
    private let KEY_END_DATE = "end_date"
    
    var startDate: Double = 0
    var endDate: Double = 0
    
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
        if let startDate = json[KEY_START_DATE] as? Double {
            self.startDate = startDate
        } else if let startDate = json[KEY_END_DATE] as? String {
            if startDate.isNumber {
                self.startDate = Double(startDate)!
            }
        }
        if let endDate = json[KEY_END_DATE] as? Double {
            self.endDate = endDate
        } else if let endDate = json[KEY_END_DATE] as? String {
            if endDate.isNumber {
                self.endDate = Double(endDate)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_START_DATE] = startDate
        json[KEY_END_DATE] = endDate
        return json
    }
}
