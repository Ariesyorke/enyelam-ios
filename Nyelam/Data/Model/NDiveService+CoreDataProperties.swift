//
//  NDiveService+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 11/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NDiveService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NDiveService> {
        return NSFetchRequest<NDiveService>(entityName: "NDiveService")
    }

    @NSManaged public var availability: Int32
    @NSManaged public var dayOnSite: Int32
    @NSManaged public var days: Int32
    @NSManaged public var diveServiceDescription: String?
    @NSManaged public var diveSpots: [DiveSpot]?
    @NSManaged public var facilities: Facilities?
    @NSManaged public var featuredImage: String?
    @NSManaged public var id: String?
    @NSManaged public var images: [String]?
    @NSManaged public var license: Bool
    @NSManaged public var maxPerson: Int32
    @NSManaged public var minPerson: Int32
    @NSManaged public var name: String?
    @NSManaged public var normalPrice: Double
    @NSManaged public var openWater: Bool
    @NSManaged public var rating: Double
    @NSManaged public var ratingCount: Int64
    @NSManaged public var schedule: Schedule?
    @NSManaged public var specialPrice: Double
    @NSManaged public var totalDays: Int32
    @NSManaged public var totalDives: Int32
    @NSManaged public var totalDiveSpots: Int32
    @NSManaged public var visited: Int64
    @NSManaged public var categories: NSSet?
    @NSManaged public var divecenter: NDiveCenter?
    @NSManaged public var licenseType: NLicenseType?
    @NSManaged public var organization: NMasterOrganization?

}

// MARK: Generated accessors for categories
extension NDiveService {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: NCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: NCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
