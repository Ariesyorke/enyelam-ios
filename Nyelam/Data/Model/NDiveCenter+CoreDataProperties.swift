//
//  NDiveCenter+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 4/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NDiveCenter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NDiveCenter> {
        return NSFetchRequest<NDiveCenter>(entityName: "NDiveCenter")
    }

    @NSManaged public var contact: Contact?
    @NSManaged public var diveDescription: String?
    @NSManaged public var featuredImage: String?
    @NSManaged public var id: String?
    @NSManaged public var imageLogo: String?
    @NSManaged public var images: [String]?
    @NSManaged public var location: Location?
    @NSManaged public var membership: Membership?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var startFromDays: Int32
    @NSManaged public var startFromPrice: Double
    @NSManaged public var startFromSpecialPrice: Double
    @NSManaged public var startFromTotalDives: Int32
    @NSManaged public var status: Int32
    @NSManaged public var subtitle: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension NDiveCenter {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: NCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: NCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
