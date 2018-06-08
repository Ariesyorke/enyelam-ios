//
//  NExperience+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 6/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NExperience {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NExperience> {
        return NSFetchRequest<NExperience>(entityName: "NExperience")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
