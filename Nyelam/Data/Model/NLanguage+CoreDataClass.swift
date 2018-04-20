//
//  NLanguage+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
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
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
    
    static func getPosition(by id: String) -> Int {
        if let languages = getLanguages(), !languages.isEmpty {
            var position = 0
            for language in languages {
                if language.id! == id {
                    return position
                }
                position += 1
            }
        }
        return 0
    }
    
    static func getLanguages() -> [NLanguage]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NLanguage")
        fetchRequest.predicate = NSPredicate(format: "id != nil && name != nil")
        do {
            let languages = try managedContext.fetch(fetchRequest) as? [NLanguage]
            if let languages = languages, !languages.isEmpty {
                return languages
            }
        } catch {
            print(error)
        }
        return nil

    }

}
