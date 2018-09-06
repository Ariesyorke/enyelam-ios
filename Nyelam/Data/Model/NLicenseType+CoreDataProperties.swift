//
//  NLicenseType+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NLicenseType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NLicenseType> {
        return NSFetchRequest<NLicenseType>(entityName: "NLicenseType")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
