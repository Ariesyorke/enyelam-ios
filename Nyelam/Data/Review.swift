//
//  Review.swift
//  Nyelam
//
//  Created by Bobi on 6/25/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

class Review: NSObject, Parseable {
    private let KEY_ID = "id"
    private let KEY_DATE = "date"
    private let KEY_CONTENT = "content"
    private let KEY_USER = "user"
    private let KEY_RATING = "rating"
    
    var id: String?
    var date: Date?
    var content: String?
    var user: NUser?
    var rating: Double = 0

    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        if let timestamp = json[KEY_DATE] as? Double {
            self.date = Date(timeIntervalSince1970: timestamp)
        } else if let timestamp = json[KEY_DATE] as? String {
            if timestamp.isNumber {
                self.date = Date(timeIntervalSince1970: TimeInterval(timestamp)!)
            }
        }
        self.content = json[KEY_CONTENT] as? String
        if let userJson = json[KEY_USER] as? [String: Any] {
            if let id = userJson["user_id"] as? String {
                self.user = NUser.getUser(using: id)
            }
            if self.user == nil {
                self.user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                self.user!.parse(json: userJson)
            }
        } else if let userString = json[KEY_USER] as? String {
            do {
                let data = userString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let userJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = userJson["user_id"] as? String {
                    self.user = NUser.getUser(using: id)
                }
                if self.user == nil {
                    self.user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.user!.parse(json: userJson)
            } catch {
                print(error)
            }
        }
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let date = self.date {
            json[KEY_DATE] = date
        }
        if let content = self.content {
            json[KEY_CONTENT] = content
        }
        if let user = self.user {
            json[KEY_USER] = user.serialized()
        }
        json[KEY_RATING] = rating
        return json
    }
}
