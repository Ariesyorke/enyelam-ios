//
//  NProduct+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NProduct> {
        return NSFetchRequest<NProduct>(entityName: "NProduct")
    }

    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var featuredImage: String?
    @NSManaged public var normalPrice: Double
    @NSManaged public var specialPrice: Double
    @NSManaged public var images: [String]?
    @NSManaged public var status: String?
    @NSManaged public var color: String?
    @NSManaged public var hexColor: String?
    @NSManaged public var sizes: [Size]?
    @NSManaged public var productDescription: String?
    @NSManaged public var variations: NSSet?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for variations
extension NProduct {

    @objc(addVariationsObject:)
    @NSManaged public func addToVariations(_ value: NProduct)

    @objc(removeVariationsObject:)
    @NSManaged public func removeFromVariations(_ value: NProduct)

    @objc(addVariations:)
    @NSManaged public func addToVariations(_ values: NSSet)

    @objc(removeVariations:)
    @NSManaged public func removeFromVariations(_ values: NSSet)

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
