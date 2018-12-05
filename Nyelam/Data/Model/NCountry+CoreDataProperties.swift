//
//  NCountry+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 05/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NCountry> {
        return NSFetchRequest<NCountry>(entityName: "NCountry")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
