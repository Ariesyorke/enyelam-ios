//
//  SearchService.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class SearchResultService: SearchResult {
    private let KEY_LICENSE = "license"
    
    var license: Bool = false
    
    override init(json: [String: Any]) {
        super.init(json: json)
        self.parse(json: json)
    }
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        json[KEY_LICENSE] = license
        
        return json
    }
}
