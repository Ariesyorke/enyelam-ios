//
//  Contact.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Contact: NSObject, Parseable {
    private let KEY_NAME = "name"
    private let KEY_EMAIL_ADDRESS = "email_address"
    private let KEY_EMAIL = "email"
    private let KEY_PHONE_NUMBER = "phone_number"
    private let KEY_COUNTRY_CODE = "country_code"
    private let KEY_LOCATION = "location"
    
    var name: String?
    var emailAddress: String?
    var phoneNumber: String?
    var countryCode: String?
    var location: Location?
    override init() {}
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.name = json[KEY_NAME] as? String
        if let email = json[KEY_EMAIL] as? String {
            self.emailAddress = email
        } else if let email = json[KEY_EMAIL_ADDRESS] as? String {
            self.emailAddress = email
        }
        self.phoneNumber = json[KEY_PHONE_NUMBER] as? String
        self.countryCode = json[KEY_COUNTRY_CODE] as? String
        if let locationJson = json[KEY_LOCATION] as? [String: Any] {
            self.location = Location(json: locationJson)
        } else if let locationString = json[KEY_LOCATION] as? String {
            do {
                let data = locationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let locationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.location = Location(json: locationJson)
            } catch {
                print(error)
            }

        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let email = self.emailAddress {
            json[KEY_EMAIL_ADDRESS] = email
        }
        if let phoneNumber = self.phoneNumber {
            json[KEY_PHONE_NUMBER] = phoneNumber
        }
        if let countryCode = self.countryCode {
            json[KEY_COUNTRY_CODE] = countryCode
        }
        if let location = location {
            json[KEY_LOCATION] = location.serialized()
        }
        return json
    }
}
