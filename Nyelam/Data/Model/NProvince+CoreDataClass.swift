//
//  NProvince+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NProvince)
public class NProvince: NSManagedObject {
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
    
    static func getProvince(using id: String) -> NProvince? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NProvince")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let provinces = try managedContext.fetch(fetchRequest) as? [NProvince]
            if let provinces = provinces, !provinces.isEmpty {
                return provinces.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
