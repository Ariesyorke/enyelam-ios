//
//  Update.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Update: Parseable {
    private let KEY_LATEST_VERSION = "latest_version"
    private let KEY_WORDING = "wording"
    private let KEY_LINK = "link"
    private let KEY_IS_MUST = "is_must"
    
    var latestVersion: Int = 0
    var isMust: Bool = false
    var wording: String?
    var link: String?
    
    func parse(json: [String : Any]) {
        if let latestVersion = json[KEY_LATEST_VERSION] as? Int {
            self.latestVersion = latestVersion
        } else if let latestVersion = json[KEY_LATEST_VERSION] as? String {
            if latestVersion.isNumber {
                self.latestVersion = Int(latestVersion)!
            }
        }
        if let isMust = json[KEY_IS_MUST] as? Bool {
            self.isMust = isMust
        } else if let isMust = json[KEY_IS_MUST] as? String {
            self.isMust = isMust.toBool
        }
        self.wording = json[KEY_WORDING] as? String
        self.link = json[KEY_LINK] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_LATEST_VERSION] = self.latestVersion
        json[KEY_IS_MUST] = self.isMust
        if let wording = self.wording {
            json[KEY_WORDING] = wording
        }
        if let link = self.link {
            json[KEY_LINK] = link
        }
        return json
    }

}
