//
//  NProductCategory+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NProductCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NProductCategory> {
        return NSFetchRequest<NProductCategory>(entityName: "NProductCategory")
    }

    @NSManaged public var categoryImage: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var id: String?

}
