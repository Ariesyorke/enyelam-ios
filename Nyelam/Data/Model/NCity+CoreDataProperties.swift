//
//  NCity+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 5/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NCity> {
        return NSFetchRequest<NCity>(entityName: "NCity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var province: NProvince?

}
