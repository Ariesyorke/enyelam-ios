//
//  URLBanner.swift
//  Nyelam
//
//  Created by Bobi on 6/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class URLBanner: Banner {
    private let KEY_URL = "url"
    
    var url: String?
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        self.url = json[KEY_URL] as? String
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        if let url = self.url {
            json[KEY_URL] = url
        }
        return json
    }
}
