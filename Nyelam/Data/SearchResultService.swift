//
//  SearchService.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class SearchResultService: SearchResult {
    private let KEY_DIVESPOT = "dive_spot"
    private let KEY_DIVESERVICE = "dive_service"
    private let KEY_LICENSE = "license"
    
    var diveSpot: String?
    var diveService: String?
    var license: Bool = false
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        self.diveSpot = json[KEY_DIVESPOT] as? String
        self.diveService = json[KEY_DIVESERVICE] as? String
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        
        if let diveSpot = self.diveSpot {
            json[KEY_DIVESPOT] = diveSpot
        }
        
        if let diveService = self.diveService {
            json[KEY_DIVESERVICE] = diveService
        }
        
        json[KEY_LICENSE] = license
        
        return json
    }
}
