//
//  NSearchResult+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 5/22/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NSearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSearchResult> {
        return NSFetchRequest<NSearchResult>(entityName: "NSearchResult")
    }

    @NSManaged public var count: Int64
    @NSManaged public var id: String?
    @NSManaged public var license: Bool
    @NSManaged public var name: String?
    @NSManaged public var province: String?
    @NSManaged public var rating: Double
    @NSManaged public var type: Int16

}
