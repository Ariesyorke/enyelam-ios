//
//  NShippingAddress+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NShippingAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NShippingAddress> {
        return NSFetchRequest<NShippingAddress>(entityName: "NShippingAddress")
    }

    @NSManaged public var addressId: String?
    @NSManaged public var fullname: String?
    @NSManaged public var address: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var isPicked: Bool
    @NSManaged public var phoneNumber: String?
    @NSManaged public var city: NCity?
    @NSManaged public var district: NDistrict?
    @NSManaged public var province: NProvince?

}
