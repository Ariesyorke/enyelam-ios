//
//  NExperience+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NExperience)
public class NExperience: NSManagedObject {    
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
    
    static func getExperience(using id: String) -> NExperience? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NExperience")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let experiences = try managedContext.fetch(fetchRequest) as? [NExperience]
            if let experiences = experiences, !experiences.isEmpty {
                return experiences.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
