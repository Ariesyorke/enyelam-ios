//
//  Facilities.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Facilities: NSObject, NSCoding, Parseable {
    private let KEY_DIVE_GUIDE = "dive_guide"
    private let KEY_FOOD = "food"
    private let KEY_TOWEL = "towel"
    private let KEY_DIVE_EQUIPMENT = "dive_equipment"
    private let KEY_LICENSE = "license"
    private let KEY_TRANSPORTATION = "transportation"
    private let KEY_ACCOMODATION = "accomodation"
    
    var diveGuide: Bool = false
    var food: Bool = false
    var towel: Bool = false
    var diveEquipment: Bool = false
    var license: Bool = false
    var transportation: Bool = false
    var accomodation: Bool = false
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }
    
    override init() {}
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        if let diveGuide = json[KEY_DIVE_GUIDE] as? Bool {
            self.diveGuide = diveGuide
        } else if let diveGuide = json[KEY_DIVE_GUIDE] as? String {
            self.diveGuide = diveGuide.toBool
        }
        if let food = json[KEY_FOOD] as? Bool {
            self.food = food
        } else if let food = json[KEY_FOOD] as? String {
            self.food = food.toBool
        }
        if let towel = json[KEY_TOWEL] as? Bool {
            self.towel = towel
        } else if let towel = json[KEY_TOWEL] as? String {
            self.towel = towel.toBool
        }
        if let diveEquipment = json[KEY_DIVE_EQUIPMENT] as? Bool {
            self.diveEquipment = diveEquipment
        } else if let diveEquipment = json[KEY_DIVE_EQUIPMENT] as? String {
            self.diveEquipment = diveEquipment.toBool
        }
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
        if let transportation = json[KEY_TRANSPORTATION] as? Bool {
            self.transportation = transportation
        } else if let transportation = json[KEY_TRANSPORTATION] as? String {
            self.transportation = transportation.toBool
        }
        if let accomodation = json[KEY_ACCOMODATION] as? Bool {
            self.accomodation = accomodation
        } else if let accomodation = json[KEY_TRANSPORTATION] as? String {
            self.accomodation = accomodation.toBool
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_DIVE_GUIDE] = self.diveGuide
        json[KEY_FOOD] = self.food
        json[KEY_TOWEL] = self.towel
        json[KEY_DIVE_EQUIPMENT] = self.diveEquipment
        json[KEY_LICENSE] = self.license
        json[KEY_TRANSPORTATION] = self.transportation
        json[KEY_ACCOMODATION] = self.accomodation
        return json
    }
    
}
