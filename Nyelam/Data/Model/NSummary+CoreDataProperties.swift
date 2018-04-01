//
//  NSummary+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NSummary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSummary> {
        return NSFetchRequest<NSummary>(entityName: "NSummary")
    }

    @NSManaged public var contactJson: String?
    @NSManaged public var id: String?
    @NSManaged public var participantJson: String?
    @NSManaged public var diveService: NDiveService?
    @NSManaged public var order: NOrder?

}
