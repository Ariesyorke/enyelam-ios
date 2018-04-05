//
//  NCountryCode+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NCountryCode)
public class NCountryCode: NSManagedObject {
    private let KEY_ID = "id"
    private let KEY_COUNTRY_CODE = "country_code"
    private let KEY_COUNTRY_NAME = "country_name"
    private let KEY_COUNTRY_NUMBER = "country_number"
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.countryCode = json[KEY_COUNTRY_CODE] as? String
        self.countryName = json[KEY_COUNTRY_NAME] as? String
        self.countryNumber = json[KEY_COUNTRY_NUMBER] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let countryCode = self.countryCode {
            json[KEY_COUNTRY_CODE] = countryCode
        }
        if let countryName = self.countryName {
            json[KEY_COUNTRY_NAME] = countryName
        }
        if let countryNumber = self.countryNumber {
            json[KEY_COUNTRY_NUMBER] = countryNumber
        }
        
        return json
    }
    
    static func getCountryCode(using id: String) -> NCountryCode? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                return countryCodes.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func deleteCountryCode(by id: String) -> Bool {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                let countryCode = countryCodes.first!
                managedContext.delete(countryCode)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }

}
