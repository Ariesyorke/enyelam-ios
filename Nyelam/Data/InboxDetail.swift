//
//  InboxDetail.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class InboxDetail: Parseable {
    
    private let KEY_ID = "id"
    private let KEY_USER_ID = "user_id"
    private let KEY_USER_NAME = "user_name"
    private let KEY_SUBJECT_DETAIL = "subject_detail"
    private let KEY_ATTACHMENT = "attachment"
    private let KEY_DATE = "date"
    
    var id: String?
    var userId: String?
    var userName: String?
    var message: String?
    var attachment: String?
    var date: Date?
    var messageType: String = "Text"
    
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.userId = json[KEY_USER_ID] as? String
        self.userName = json[KEY_USER_NAME] as? String
        self.message = json[KEY_SUBJECT_DETAIL] as? String
        self.attachment = json[KEY_ATTACHMENT] as? String
        if let timestamp = json[KEY_DATE] as? Double {
            self.date = Date(timeIntervalSince1970: timestamp)
        } else if let timestamp = json[KEY_DATE] as? String {
            if timestamp.isNumber {
                self.date = Date(timeIntervalSince1970: Double(timestamp)!)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let userId = self.userId {
            json[KEY_USER_ID] = userId
        }
        if let userName = self.userName {
            json[KEY_USER_NAME] = userName
        }
        if let message = self.message {
            json[KEY_SUBJECT_DETAIL] = message
        }
        if let attachment = self.attachment {
            json[KEY_ATTACHMENT] = attachment
        }
        if let date = self.date {
            json[KEY_DATE] = date.timeIntervalSince1970
        }
        return json
    }
    
    
}
