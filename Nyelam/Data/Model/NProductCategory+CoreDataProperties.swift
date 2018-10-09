//
//  NProductCategory+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 10/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NProductCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NProductCategory> {
        return NSFetchRequest<NProductCategory>(entityName: "NProductCategory")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?

}
