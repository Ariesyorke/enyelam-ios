//
//  Courier.swift
//  Nyelam
//
//  Created by Bobi on 11/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class Courier: Parseable {
    private let KEY_CODE = "code"
    private let KEY_NAME = "name"
    private let KEY_COSTS = "costs"
    
    var code: String?
    var name: String?
    var courierTypes: [CourierType]?
    
    init() {}
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.code = json[KEY_CODE] as? String
        self.name = json[KEY_NAME] as? String
        if let typesArray = json[KEY_COSTS] as? Array<[String: Any]> {
            self.courierTypes = []
            for typeJson in typesArray {
                let courierType = CourierType(json: typeJson)
                self.courierTypes!.append(courierType)
            }
        } else if let typeString = json[KEY_COSTS] as? String {
            do {
                let data = typeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let typesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.courierTypes = []
                for typeJson in typesArray {
                    let courierType = CourierType(json: typeJson)
                    self.courierTypes!.append(courierType)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let code = self.code {
            json[KEY_CODE] = code
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let courierTypes = self.courierTypes, !courierTypes.isEmpty {
            var array: Array<[String: Any]> = []
            for courierType in courierTypes {
                array.append(courierType.serialized())
            }
            json[KEY_COSTS] = array
        }
        return json
    }

}
