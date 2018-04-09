//
//  SearchResultSpot.swift
//  Nyelam
//
//  Created by Bobi on 4/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class SearchResultSpot: SearchResult {
    private let KEY_PROVINCE = "province"
    var province: String?
    
    override init(json: [String: Any]) {
        super.init(json: json)
        self.parse(json: json)
    }
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        self.province = json[KEY_PROVINCE] as? String
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        if let province = self.province {
            json[KEY_PROVINCE] = province
        }
        return json
    }
}
