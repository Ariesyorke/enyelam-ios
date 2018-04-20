//
//  CoreData+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    static func saveData() {
        
        let managedContext = AppDelegate.sharedManagedContext
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    static func saveData(completion: ()->()) {
        let managedContext = AppDelegate.sharedManagedContext
        do {
            try managedContext.save()
            completion()
        } catch {
            print(error)
        }
    }

}
