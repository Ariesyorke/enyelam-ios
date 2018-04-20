//
//  Module.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Module: NSObject, Parseable {
    private var KEY_MODULE_NAME = "module_name"
    
    var name: String?
    override init() {
        super.init()
    }
    
    func parse(json: [String : Any]) {
        self.name = json["module_name"] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let name = self.name {
            json[KEY_MODULE_NAME] = name
        }
        return json
    }
}
