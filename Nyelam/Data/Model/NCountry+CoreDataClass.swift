//
//  NCountry+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NCountry)
public class NCountry: NSManagedObject {
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
    
    static func getCountry(using id: String) -> NCountry? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountry")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countries = try managedContext.fetch(fetchRequest) as? [NCountry]
            if let countries = countries, !countries.isEmpty {
                return countries.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}
