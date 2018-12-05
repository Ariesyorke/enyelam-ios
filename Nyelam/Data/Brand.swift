//
//  Brand.swift
//  Nyelam
//
//  Created by Bobi on 05/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Brand: NSObject, NSCoding, Parseable {
    private let KEY_ID = "id"
    private let KEY_BRAND_NAME = "brand_name"
    private let KEY_BRAND_LOGO = "brand_logo"
    
    var id: String?
    var name: String?
    var image: String?
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_BRAND_NAME] as? String
        self.image = json[KEY_BRAND_LOGO] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_BRAND_NAME] = name
        }
        if let image = self.image {
            json[KEY_BRAND_LOGO] = image
        }
        return json
    }
}
