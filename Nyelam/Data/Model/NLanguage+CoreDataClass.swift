//
//  NLanguage+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NLanguage)
public class NLanguage: NSManagedObject {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        return json
    }
    static func getLanguage(using id: String) -> NLanguage? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NLanguage")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let languages = try managedContext.fetch(fetchRequest) as? [NLanguage]
            if let languages = languages, !languages.isEmpty {
                return languages.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
