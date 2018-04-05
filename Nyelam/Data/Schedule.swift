//
//  Schedule.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Schedule: NSObject, Parseable {
    private let KEY_START_DATE = "start_date"
    private let KEY_END_DATE = "end_date"
    
    var startDate: Double = 0
    var endDate: Double = 0
    
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
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_START_DATE] = startDate
        json[KEY_END_DATE] = endDate
        return json
    }
}
