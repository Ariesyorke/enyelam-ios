//
//  NProvince+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 05/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NProvince {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NProvince> {
        return NSFetchRequest<NProvince>(entityName: "NProvince")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var city: NSSet?

}

// MARK: Generated accessors for city
extension NProvince {

    @objc(addCityObject:)
    @NSManaged public func addToCity(_ value: NCity)

    @objc(removeCityObject:)
    @NSManaged public func removeFromCity(_ value: NCity)

    @objc(addCity:)
    @NSManaged public func addToCity(_ values: NSSet)

    @objc(removeCity:)
    @NSManaged public func removeFromCity(_ values: NSSet)

}
