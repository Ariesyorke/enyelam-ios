//
//  Inbox.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class Inbox: Parseable {
    private let KEY_TICKET_ID = "ticket_id"
    private let KEY_SUBJECT = "subject"
    private let KEY_NAME = "name"
    private let KEY_REF_ID = "ref_id"
    private let KEY_STATUS = "status"
    private let KEY_DATE = "date"
    private let KEY_INBOX_TYPE = "inbox_type"
    private let KEY_DATA = "data"
    
    var ticketId: String?
    var subject: String?
    var name: String?
    var refId: String?
    var status: String?
    var date: Date?
    var inboxType: Int = -1
    var inboxDetails: [InboxDetail]?
    init () {}
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.ticketId = json[KEY_TICKET_ID] as? String
        self.subject = json[KEY_SUBJECT] as? String
        self.name = json[KEY_NAME] as? String
        self.refId = json[KEY_REF_ID] as? String
        self.status = json[KEY_STATUS] as? String
        if let timestamp = json[KEY_DATE] as? Double {
            self.date = Date(timeIntervalSince1970: timestamp)
        } else if let timestamp = json[KEY_DATE] as? String {
            if timestamp.isNumber {
                self.date = Date(timeIntervalSince1970: Double(timestamp)!)
            }
        }
        if let inboxType = json[KEY_INBOX_TYPE] as? Int {
            self.inboxType = inboxType
        } else if let inboxType = json[KEY_INBOX_TYPE] as? String {
            if inboxType.isNumber {
                self.inboxType = Int(inboxType)!
            }
        }
        if let inboxDetailArray = json[KEY_DATA] as? Array<[String: Any]>, !inboxDetailArray.isEmpty {
            self.inboxDetails = []
            for inboxDetailJson in inboxDetailArray {
                let inboxDetail = InboxDetail(json: inboxDetailJson)
                self.inboxDetails!.append(inboxDetail)
            }
        } else if let inboxDetailString = json[KEY_DATA] as? String {
            do {
                let data = inboxDetailString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let inboxDetailArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.inboxDetails = []
                for inboxDetailJson in inboxDetailArray {
                    let inboxDetail = InboxDetail(json: inboxDetailJson)
                    self.inboxDetails!.append(inboxDetail)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let ticketId = self.ticketId {
            json[KEY_TICKET_ID] = ticketId
        }
        if let subject = self.subject {
            json[KEY_SUBJECT] = subject
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let refId = self.refId {
            json[KEY_REF_ID] = refId
        }
        if let status = self.status {
            json[KEY_STATUS] = status
        }
        if let date = self.date {
            json[KEY_DATE] = date.timeIntervalSince1970
        }
        if let inboxDetails = self.inboxDetails, !inboxDetails.isEmpty {
            var array: Array<[String: Any]> = []
            for inboxDetail in inboxDetails {
                array.append(inboxDetail.serialized())
            }
            json[KEY_DATA] = array
        }
        json[KEY_INBOX_TYPE] = self.inboxType
        return json
    }
}
