//
//  NMasterOrganization+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 5/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NMasterOrganization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NMasterOrganization> {
        return NSFetchRequest<NMasterOrganization>(entityName: "NMasterOrganization")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
