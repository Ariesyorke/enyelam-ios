//
//  NDistrict+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 05/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NDistrict {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NDistrict> {
        return NSFetchRequest<NDistrict>(entityName: "NDistrict")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
