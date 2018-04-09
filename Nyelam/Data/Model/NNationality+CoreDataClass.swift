//
//  NNationality+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NNationality)
public class NNationality: NSManagedObject {
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
    
    static func getNationality(using id: String) -> NNationality? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NNationality")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let nationalities = try managedContext.fetch(fetchRequest) as? [NNationality]
            if let nationalities = nationalities, !nationalities.isEmpty {
                return nationalities.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
