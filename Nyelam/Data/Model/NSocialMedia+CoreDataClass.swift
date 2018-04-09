//
//  NSocialMedia+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NSocialMedia)
public class NSocialMedia: NSManagedObject {
    private let KEY_TYPE = "type"
    private let KEY_ID = "id"
    
    func parse(json: [String : Any]) {
        self.type = json[KEY_TYPE] as? String
        self.id = json[KEY_ID] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let type = self.type {
            json[KEY_TYPE] = type
        }
        if let id = self.id {
            json[KEY_ID] = id
        }
        return json
    }
    
    static func getSocialMedia(using id: String, and type: String) -> NSocialMedia? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSocialMedia")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND type == %@", id, type)
        do {
            let socialMedias = try managedContext.fetch(fetchRequest) as? [NSocialMedia]
            if let socialMedias = socialMedias, !socialMedias.isEmpty {
                return socialMedias.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
