//
//  NCountryCode+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 11/30/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NCountryCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NCountryCode> {
        return NSFetchRequest<NCountryCode>(entityName: "NCountryCode")
    }

    @NSManaged public var countryCode: String?
    @NSManaged public var countryName: String?
    @NSManaged public var countryNumber: String?
    @NSManaged public var id: String?

}
