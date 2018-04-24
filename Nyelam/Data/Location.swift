//
//  Location.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

public class Location: NSObject, NSCoding, Parseable {
    private let KEY_COUNTRY = "country"
    private let KEY_PROVINCE = "province"
    private let KEY_CITY = "city"
    private let KEY_COORDINATE = "coordinate"
    
    var country: String?
    var province: NProvince?
    var city: NCity?
    var coordinate: Coordinate?
    
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
        self.country = json[KEY_COUNTRY] as? String
        if let provinceJson = json[KEY_PROVINCE] as? [String: Any] {
            if let id = provinceJson["id"] as? String {
                self.province = NProvince.getProvince(using: id)
            }
            if self.province == nil {
                self.province = NSEntityDescription.insertNewObject(forEntityName: "NProvince", into: AppDelegate.sharedManagedContext) as! NProvince
            }
            self.province!.parse(json: provinceJson)
        } else if let provinceString = json[KEY_PROVINCE] as? String {
            do {
                let data = provinceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let provinceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = provinceJson["id"] as? String {
                    self.province = NProvince.getProvince(using: id)
                }
                if self.province == nil {
                    self.province = NSEntityDescription.insertNewObject(forEntityName: "NProvince", into: AppDelegate.sharedManagedContext) as! NProvince
                    
                }
                self.province!.parse(json: provinceJson)
            } catch {
                print(error)
            }
        }
        if let cityJson = json[KEY_CITY] as? [String: Any] {
            if let id = cityJson["id"] as? String {
                self.city = NCity.getCity(using: id)
            }
            if self.city == nil {
                self.city = NSEntityDescription.insertNewObject(forEntityName: "NCity", into: AppDelegate.sharedManagedContext) as! NCity
            }
            self.city!.parse(json: cityJson)
        } else if let cityString = json[KEY_CITY] as? String {
            do {
                let data = cityString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let cityJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = cityJson["id"] as? String {
                    self.city = NCity.getCity(using: id)
                }
                if self.city == nil {
                    self.city = NSEntityDescription.insertNewObject(forEntityName: "NCity", into: AppDelegate.sharedManagedContext) as! NCity
                }
                self.city!.parse(json: cityJson)
            } catch {
                print(error)
            }
        }
        if let coordinateJson = json[KEY_COORDINATE] as? [String: Any] {
            self.coordinate = Coordinate(json: coordinateJson)
        } else if let coordinateString = json[KEY_COORDINATE] as? String {
            do {
                let data = coordinateString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let coordinateJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.coordinate = Coordinate(json: coordinateJson)
            } catch {
                print(error)
            }
        }
    }
    
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let country = country {
            json[KEY_COUNTRY] = country
        }
        if let province = province {
            json[KEY_PROVINCE] = province.serialized()
        }
        if let city = city {
            json[KEY_CITY] = city.serialized()
        }
        if let coordinate = coordinate {
            json[KEY_COORDINATE] = coordinate
        }
        return json
    }
    
}
