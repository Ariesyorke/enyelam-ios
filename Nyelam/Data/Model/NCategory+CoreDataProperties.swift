//
//  NCategory+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 05/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NCategory> {
        return NSFetchRequest<NCategory>(entityName: "NCategory")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
