//
//  CourierType.swift
//  Nyelam
//
//  Created by Bobi on 11/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class CourierType: Parseable {
    private let KEY_SERVICE = "service"
    private let KEY_DESCRPTION = "description"
    private let KEY_COST = "cost"
    
    var service: String?
    var serviceDescription: String?
    var costs: [CourierCost]?
    
    init() {}
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.service = json[KEY_SERVICE] as? String
        self.serviceDescription = json[KEY_DESCRPTION] as? String
        if let costArray = json[KEY_COST] as? Array<[String: Any]>, !costArray.isEmpty {
            self.costs = []
            for costJson in costArray {
                let cost = CourierCost(json: costJson)
                self.costs!.append(cost)
            }
        } else if let costArrayString = json[KEY_COST] as? String {
            do {
                let data = costArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let costArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.costs = []
                for costJson in costArray {
                    let cost = CourierCost(json: costJson)
                    self.costs!.append(cost)
                }
            } catch {
                print(error)
            }

        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let service = self.service {
            json[KEY_SERVICE] = service
        }
        if let serviceDescription = self.serviceDescription {
            json[KEY_DESCRPTION] = serviceDescription
        }
        if let costs = self.costs, !costs.isEmpty {
            var array: Array<[String: Any]> = []
            for cost in costs {
                array.append(cost.serialized())
            }
            json[KEY_COST] = array
        }
        return json
    }
}
