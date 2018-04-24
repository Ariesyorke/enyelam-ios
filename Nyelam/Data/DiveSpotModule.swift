//
//  DiveSpotModule.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

public class DiveSpotModule: Module, NSCoding {
    private let KEY_DIVE_SPOTS = "dive_spots"
    
    var divespots: [DiveSpot]?
    
    override init() {
        super.init()
    }
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
    

    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        if let diveSpotArray = json[KEY_DIVE_SPOTS] as? Array<[String: Any]>, !diveSpotArray.isEmpty {
            self.divespots = []
            for diveSpotJson in diveSpotArray {
                let diveSpot = DiveSpot(json: diveSpotJson)
                self.divespots!.append(diveSpot)
            }
        } else if let diveSpotString = json[KEY_DIVE_SPOTS] as? String {
            do {
                let data = diveSpotString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let diveSpotArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.divespots = []
                for diveSpotJson in diveSpotArray {
                    let diveSpot = DiveSpot(json: diveSpotJson)
                    self.divespots!.append(diveSpot)
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func serialized() -> [String : Any] {
        var json: [String: Any] = super.serialized()
        
        
        if let divespots = self.divespots, !divespots.isEmpty {
            var array: Array<[String: Any]> = []
            for divespot in divespots {
                array.append(divespot.serialized())
            }
            json[KEY_DIVE_SPOTS] = array
        }
        
        return json
        
    }
}
