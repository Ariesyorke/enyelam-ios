//
//  ServiceBanner.swift
//  Nyelam
//
//  Created by Bobi on 6/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class ServiceBanner: Banner {
    private let KEY_SERVICE_ID = "service_id"
    private let KEY_DATE = "date"
    
    var serviceId: String?
    var date: Date?
    
    override init(json: [String : Any]) {
        super.init(json: json)
    }
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        self.serviceId = json[KEY_SERVICE_ID] as? String
        if let timestamp = json[KEY_DATE] as? Int {
            self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        } else if let timestamp = json[KEY_DATE] as? String {
            if timestamp.isNumber {
                self.date = Date(timeIntervalSince1970: TimeInterval(timestamp)!)
            }
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        if let serviceId = self.serviceId {
            json[KEY_SERVICE_ID] = serviceId
        }
        if let date = self.date {
            json[KEY_DATE] = date.timeIntervalSince1970
        }
        return json
    }
}
