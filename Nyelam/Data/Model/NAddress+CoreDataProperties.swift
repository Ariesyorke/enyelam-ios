//
//  NAddress+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NAddress> {
        return NSFetchRequest<NAddress>(entityName: "NAddress")
    }

    @NSManaged public var address: String?
    @NSManaged public var addressId: String?
    @NSManaged public var default_billling: Int16
    @NSManaged public var default_shipping: Int16
    @NSManaged public var emailAddress: String?
    @NSManaged public var fullname: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var city: NCity?
    @NSManaged public var district: NDistrict?
    @NSManaged public var province: NProvince?

}
