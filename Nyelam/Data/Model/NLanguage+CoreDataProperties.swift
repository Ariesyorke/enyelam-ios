//
//  NLanguage+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 10/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NLanguage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NLanguage> {
        return NSFetchRequest<NLanguage>(entityName: "NLanguage")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
