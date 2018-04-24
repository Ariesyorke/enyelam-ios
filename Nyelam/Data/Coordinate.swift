//
//  Coordinate.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Coordinate: NSObject, NSCoding, Parseable {
    private let KEY_LAT = "lat"
    private let KEY_LON = "lon"
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    override init(){}
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }

    func parse(json: [String : Any]) {
        if let latitude = json[KEY_LAT] as? Double {
            self.latitude = latitude
        } else if let latitude = json[KEY_LAT] as? String {
            if latitude.isNumber {
                self.latitude = Double(latitude)!
            }
        }
        if let longitude = json[KEY_LON] as? Double {
            self.longitude = longitude
        } else if let longitude = json[KEY_LON] as? String {
            self.longitude = Double(longitude)!
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_LAT] = latitude
        json[KEY_LON] = longitude
        return json
    }
}
