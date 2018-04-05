//
//  BookingContact.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

public class BookingContact: NSObject, Parseable {
    private let KEY_NAME = "name"
    private let KEY_PHONE_NUMBER = "phone_number"
    private let KEY_EMAIL = "email"
    private let KEY_COUNTRY_CODE = "country_code"
    
    var name: String?
    var phoneNumber: String?
    var email: String?
    var countryCode: NCountryCode?
    
    override init() {
        super.init()
    }
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    func parse (json: [String: Any]) {
        self.name = json[KEY_NAME] as? String
        self.phoneNumber = json[KEY_PHONE_NUMBER] as? String
        self.email = json[KEY_EMAIL] as? String
        if let countryCodeJson = json[KEY_COUNTRY_CODE] as? [String: Any] {
            if let id = countryCodeJson["id"] as? String {
                countryCode = NCountryCode.getCountryCode(using: id)
            }
            if countryCode == nil {
                countryCode = NCountryCode()
            }
            countryCode!.parse(json: countryCodeJson)
        } else if let countryCodeString = json[KEY_COUNTRY_CODE] as? String {
            do {
                let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryCodeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryCodeJson["id"] as? String {
                    countryCode = NCountryCode.getCountryCode(using: id)
                }
                if countryCode == nil {
                    countryCode = NCountryCode()
                }
                countryCode!.parse(json: countryCodeJson)
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
        if let phoneNumber = self.phoneNumber {
            json[KEY_PHONE_NUMBER] = phoneNumber
        }
        if let email = self.email {
            json[KEY_EMAIL] = email
        }
        if let countryCode = self.countryCode {
            json[KEY_COUNTRY_CODE] = countryCode
        }
        return json
    }
}
