//
//  NCategory+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NCategory)
public class NCategory: NSManagedObject {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_ICON = "icon"
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        self.icon = json[KEY_ICON] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let icon = self.icon {
            json[KEY_ICON] = icon
        }
        return json
    }
    
    static func getCategory(using id: String) -> NCategory? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCategory")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let categories = try managedContext.fetch(fetchRequest) as? [NCategory]
            if let categories = categories, !categories.isEmpty {
                return categories.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}
