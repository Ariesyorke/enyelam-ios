//
//  NOrder+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 7/11/18.
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
    @NSManaged public var orderId: String?
    @NSManaged public var schedule: Double
    @NSManaged public var status: String?

}
