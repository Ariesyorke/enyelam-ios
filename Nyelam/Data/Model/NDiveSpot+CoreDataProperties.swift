//
//  NDiveSpot+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NDiveSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NDiveSpot> {
        return NSFetchRequest<NDiveSpot>(entityName: "NDiveSpot")
    }

    @NSManaged public var currentStatus: String?
    @NSManaged public var depthMax: Double
    @NSManaged public var depthMin: Double
    @NSManaged public var diveSpotDescription: String?
    @NSManaged public var diveSpotShortDescription: String?
    @NSManaged public var featuredImage: String?
    @NSManaged public var greatFor: String?
    @NSManaged public var hightlight: String?
    @NSManaged public var id: String?
    @NSManaged public var images: [String]?
    @NSManaged public var locationJson: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var recomendedStayMax: Int64
    @NSManaged public var recomendedStayMin: Int64
    @NSManaged public var statusActive: Int64
    @NSManaged public var surfaceCondition: String?
    @NSManaged public var temperatureMax: Double
    @NSManaged public var temperatureMin: Double
    @NSManaged public var visibilityMax: Double
    @NSManaged public var visibiltyMin: Double
    @NSManaged public var experienceMax: NExperience?
    @NSManaged public var experienceMin: NExperience?

}
