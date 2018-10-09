//
//  NAuthReturn+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 10/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NAuthReturn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NAuthReturn> {
        return NSFetchRequest<NAuthReturn>(entityName: "NAuthReturn")
    }

    @NSManaged public var token: String?
    @NSManaged public var user: NUser?

}
