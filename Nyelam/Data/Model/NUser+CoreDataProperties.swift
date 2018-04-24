//
//  NUser+CoreDataProperties.swift
//  Nyelam
//
//  Created by Bobi on 4/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData


extension NUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NUser> {
        return NSFetchRequest<NUser>(entityName: "NUser")
    }

    @NSManaged public var address: String?
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var birthPlace: String?
    @NSManaged public var certificateDate: NSDate?
    @NSManaged public var certificateNumber: String?
    @NSManaged public var cover: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var fullname: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var imageFile: NSData?
    @NSManaged public var isVerified: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var picture: String?
    @NSManaged public var referralCode: String?
    @NSManaged public var username: String?
    @NSManaged public var country: NCountry?
    @NSManaged public var countryCode: NCountryCode?
    @NSManaged public var language: NLanguage?
    @NSManaged public var nationality: NNationality?
    @NSManaged public var socialMedias: NSSet?

}

// MARK: Generated accessors for socialMedias
extension NUser {

    @objc(addSocialMediasObject:)
    @NSManaged public func addToSocialMedias(_ value: NSocialMedia)

    @objc(removeSocialMediasObject:)
    @NSManaged public func removeFromSocialMedias(_ value: NSocialMedia)

    @objc(addSocialMedias:)
    @NSManaged public func addToSocialMedias(_ values: NSSet)

    @objc(removeSocialMedias:)
    @NSManaged public func removeFromSocialMedias(_ values: NSSet)

}
