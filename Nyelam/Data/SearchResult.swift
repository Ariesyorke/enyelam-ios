//
//  SearchResult.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class SearchResult: Parseable {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_RATING = "rating"
    private let KEY_TYPE = "type"
    private let KEY_COUNT = "count"
    
    var id: String?
    var name: String?
    var rating: Double = 0
    var type: Int = -1
    var count: Int = 0
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        
        if let type = json[KEY_TYPE] as? Int {
            self.type = type
        } else if let type = json[KEY_TYPE] as? String {
            if type.isNumber {
                self.type = Int(type)!
            }
        }
        
        if let count = json[KEY_COUNT] as? Int {
            self.count = count
        } else if let count = json[KEY_COUNT] as? String {
            if count.isNumber {
                self.count = Int(count)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        json[KEY_RATING] = rating
        json[KEY_TYPE] = type
        json[KEY_COUNT] = count
        return json
    }
}
