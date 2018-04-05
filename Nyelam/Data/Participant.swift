//
//  Participant.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Participant: NSObject, Parseable {
    private let KEY_NAME = "name"
    private let KEY_EMAIL = "email"
    private let KEY_EMAIL_ADDRESS = "email_address"
    
    var name: String?
    var email: String?
    
    override init() {
        super.init()
    }
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.name = json[KEY_NAME] as? String
        if let email = json[KEY_EMAIL] as? String {
            self.email = email
        } else if let email = json[KEY_EMAIL_ADDRESS] as? String {
            self.email = email
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let email = self.email {
            json[KEY_EMAIL_ADDRESS] = email
        }
        return json
    }
}
