//
//  NAuthReturn+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NAuthReturn)
public class NAuthReturn: NSManagedObject {
    private let KEY_TOKEN = "token"
    private let KEY_USER = "user"
    
    func parse(json: [String : Any]) {
        self.token = json[KEY_TOKEN] as? String
        if let userJson = json[KEY_USER] as? [String: Any] {
            if let id = userJson["user_id"] as? String {
                self.user = NUser.getUser(using: id)
            }
            if self.user == nil {
                self.user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
            }
            self.user!.parse(json: userJson)
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
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let token = self.token {
            json[KEY_TOKEN] = token
        }
        if let user = self.user {
            json[KEY_USER] = user
        }
        return json
    }
    
    static func authUser() -> NAuthReturn? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NAuthReturn")
        do {
            let authReturns = try managedContext.fetch(fetchRequest) as? [NAuthReturn]
            if let authReturns = authReturns, !authReturns.isEmpty {
                return authReturns.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func deleteAllAuth() -> Bool {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NAuthReturn")
        do {
            let authReturns = try managedContext.fetch(fetchRequest) as? [NAuthReturn]
            if let authReturns = authReturns, !authReturns.isEmpty, let authReturn = authReturns.first {
                managedContext.delete(authReturn)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }

}
