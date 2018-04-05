//
//  NCity+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NCity)
public class NCity: NSManagedObject {
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
    
    static func getCity(using id: String) -> NCity? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let cities = try managedContext.fetch(fetchRequest) as? [NCity]
            if let cities = cities, !cities.isEmpty {
                return cities.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
