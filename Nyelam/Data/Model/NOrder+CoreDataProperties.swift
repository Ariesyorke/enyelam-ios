//
//  NOrder+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 11/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NOrder> {
        return NSFetchRequest<NOrder>(entityName: "NOrder")
    }

    @NSManaged public var additionals: [Additional]?
    @NSManaged public var cart: Cart?
    @NSManaged public var equipments: [Equipment]?
    @NSManaged public var orderDate: NSDate?
    @NSManaged public var orderId: String?
    @NSManaged public var paypalCurrency: PaypalCurrency?
    @NSManaged public var schedule: Double
    @NSManaged public var status: String?
    @NSManaged public var veritransToken: String?
    @NSManaged public var billingAddress: NAddress?
    @NSManaged public var shippingAddress: NAddress?

}
