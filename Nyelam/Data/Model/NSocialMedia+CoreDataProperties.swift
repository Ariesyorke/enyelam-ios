//
//  NSocialMedia+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 5/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NSocialMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSocialMedia> {
        return NSFetchRequest<NSocialMedia>(entityName: "NSocialMedia")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?

}
