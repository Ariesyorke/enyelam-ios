//
//  NNationality+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 6/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NNationality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NNationality> {
        return NSFetchRequest<NNationality>(entityName: "NNationality")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
