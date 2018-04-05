//
//  Membership.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Membership: NSObject, Parseable {
    private let KEY_MEMBERSHIP_TYPE = "membership_type"
    private let KEY_MEMBERSHIP_EXPIRED = "membership_expired"
    
    var membershipType: String?
    var membershipExpired: String?
    
    override init() {
        super.init()
    }
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.membershipType = json[KEY_MEMBERSHIP_TYPE] as? String
        self.membershipExpired = json[KEY_MEMBERSHIP_EXPIRED] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let membershipType = self.membershipType {
            json[KEY_MEMBERSHIP_TYPE] = membershipType
        }
        if let membershipExpired = self.membershipExpired {
            json[KEY_MEMBERSHIP_EXPIRED] = membershipExpired
        }
        return json
    }
}
