//
//  DoShopBanner.swift
//  Nyelam
//
//  Created by Bobi on 06/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class DoShopBanner: Parseable {
    private let KEY_ID = "id"
    private let KEY_BANNER_IMAGE = "banner_image"
    private let KEY_BANNER_TYPE = "type"
    private let KEY_TARGET_NAME = "target_name"
    private let KEY_TARGET = "target"
    
    var id: String?
    var bannerImage: String?
    var bannerType: String?
    var targetName: String?
    var target: String?
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.bannerImage = json[KEY_BANNER_IMAGE] as? String
        self.bannerType = json[KEY_BANNER_IMAGE] as? String
        self.targetName = json[KEY_TARGET_NAME] as? String
        self.target = json[KEY_TARGET] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let bannerImage = self.bannerImage {
            json[KEY_BANNER_IMAGE] = bannerImage
        }
        if let bannerType = self.bannerType {
            json[KEY_BANNER_TYPE] = bannerType
        }
        if let targetName = self.targetName {
            json[KEY_TARGET_NAME] = targetName
        }
        if let target = self.target {
            json[KEY_TARGET] = target
        }
        return json
    }
}
