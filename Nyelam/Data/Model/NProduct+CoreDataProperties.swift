//
//  NProduct+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 11/26/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NProduct> {
        return NSFetchRequest<NProduct>(entityName: "NProduct")
    }

    @NSManaged public var color: String?
    @NSManaged public var featuredImage: String?
    @NSManaged public var images: [String]?
    @NSManaged public var merchant: Merchant?
    @NSManaged public var normalPrice: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var specialPrice: Double
    @NSManaged public var status: String?
    @NSManaged public var variations: [Variation]?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension NProduct {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: NProductCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: NProductCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
