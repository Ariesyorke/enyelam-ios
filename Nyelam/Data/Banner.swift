//
//  Banner.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Banner: NSObject, Parseable {
    private let KEY_IMAGE_URL = "image_url"
    private let KEY_ID = "id"
    private let KEY_TYPE = "type"
    
    var id: String?
    var imageUrl: String?
    var type: Int = -1
    override public init() {
        super.init()
    }
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.imageUrl = json[KEY_IMAGE_URL] as? String
        if let type = json[KEY_TYPE] as? Int {
            self.type = type
        } else if let type = json[KEY_TYPE] as? String {
            if type.isNumber {
                self.type = Int(type)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let imageUrl = self.imageUrl {
            json[KEY_IMAGE_URL] = imageUrl
        }
        json[KEY_TYPE] = self.type
        return json
    }
}
