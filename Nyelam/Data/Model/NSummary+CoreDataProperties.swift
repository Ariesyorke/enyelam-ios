//
//  NSummary+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 11/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NSummary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSummary> {
        return NSFetchRequest<NSummary>(entityName: "NSummary")
    }

    @NSManaged public var contact: Contact?
    @NSManaged public var id: String?
    @NSManaged public var participant: [Participant]?
    @NSManaged public var diveService: NDiveService?
    @NSManaged public var order: NOrder?

}
