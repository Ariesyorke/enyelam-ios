//
//  NDiveCenter+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NDiveCenter)
public class NDiveCenter: NSManagedObject {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_SUBTITLE = "subtitle"
    private let KEY_IMAGE_LOGO = "image_logo"
    private let KEY_IMAGES = "images"
    private let KEY_RATING = "rating"
    private let KEY_CONTACT = "contact"
    private let KEY_MEMBERSHIP = "membership"
    private let KEY_STATUS = "status"
    private let KEY_DESCRIPTION = "description"
    private let KEY_LOCATION = "location"
    private let KEY_FEATURED_IMAGE = "featured_image"
    private let KEY_CATEGORIES = "categories"
    private let KEY_START_FROM_PRICE = "start_from_price"
    private let KEY_START_FROM_SPECIAL_PRICE = "start_from_special_price"
    private let KEY_START_FROM_TOTAL_DIVES = "start_from_total_dives"
    private let KEY_START_FROM_DAYS = "start_from_days"
    private let KEY_LOCATIONS = "locations"
    
    
    static func getDiveCenter(using id: String) -> NDiveCenter? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NDiveCenter")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let diveCenters = try managedContext.fetch(fetchRequest) as? [NDiveCenter]
            if let diveCenters = diveCenters, !diveCenters.isEmpty {
                return diveCenters.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        self.subtitle = json[KEY_SUBTITLE] as? String
        self.imageLogo = json[KEY_IMAGE_LOGO] as? String
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        if let images = json[KEY_IMAGES] as? [String], !images.isEmpty {
            self.images = images
        } else if let imagesString = json[KEY_IMAGES] as? String {
            do {
                let data = imagesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let images: Array<String> = try JSONSerialization.jsonObject(with: data!, options: []) as! [String]
                self.images = images
            } catch {
                print(error)
            }
        }
        if let contactJson = json[KEY_CONTACT] as? [String: Any] {
            self.contact = Contact(json: contactJson)
        } else if let contactString = json[KEY_CONTACT] as? String {
            do {
                let data = contactString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let contactJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.contact = Contact(json: contactJson)
            } catch {
                print(error)
            }
        }
        if let membershipJson = json[KEY_MEMBERSHIP] as? [String: Any] {
            self.membership = Membership(json: membershipJson)
        } else if let membershipString = json[KEY_MEMBERSHIP] as? String {
            do {
                let data = membershipString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let membershipJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.membership = Membership(json: membershipJson)
            } catch {
                print(error)
            }
        }
        if let status = json[KEY_STATUS] as? Int {
            self.status = Int32(status)
        } else if let status = json[KEY_STATUS] as? String {
            if status.isNumber {
                self.status = Int32(status)!
            }
        }
        self.diveDescription = json[KEY_DESCRIPTION] as? String
        if let locationJson = json[KEY_LOCATION] as? [String: Any] {
            self.location = Location(json: locationJson)
        } else if let locationJson = json[KEY_LOCATIONS] as? [String: Any] {
            self.location = Location(json: locationJson)
        } else if let locationString = json[KEY_LOCATION] as? String {
            do {
                let data = locationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let locationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.location = Location(json: locationJson)
            } catch {
                print(error)
            }
        } else if let locationString = json[KEY_LOCATIONS] as? String {
            do {
                let data = locationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let locationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.location = Location(json: locationJson)
            } catch {
                print(error)
            }
        }
        self.featuredImage = json[KEY_FEATURED_IMAGE] as? String
        if let categoriesArray = json[KEY_CATEGORIES] as? Array<[String: Any]>, !categoriesArray.isEmpty {
            for categoryJson in categoriesArray {
                var category: NCategory? = nil
                if let id = categoryJson["id"] as? String {
                    category = NCategory.getCategory(using: id)
                }
                if category == nil {
                    category = NCategory.init(entity: NSEntityDescription.entity(forEntityName: "NCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                category!.parse(json: categoryJson)
                self.addToCategories(category!)
            }
        } else if let categoriesString = json[KEY_CATEGORIES] as? String {
            do {
                let data = categoriesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let categoriesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for categoryJson in categoriesArray {
                    var category: NCategory? = nil
                    if let id = categoryJson["id"] as? String {
                        category = NCategory.getCategory(using: id)
                    }
                    if category == nil {
                        category = NCategory.init(entity: NSEntityDescription.entity(forEntityName: "NCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                    }
                    category!.parse(json: categoryJson)
                    self.addToCategories(category!)
                }
            } catch {
                print(error)
            }
        }
        if let startFromPrice = json[KEY_START_FROM_PRICE] as? Double {
            self.startFromPrice = startFromPrice
        } else if let startFromPrice = json[KEY_START_FROM_PRICE] as? String {
            if startFromPrice.isNumber {
                self.startFromPrice = Double(startFromPrice)!
            }
        }
        if let startFromSpecialPrice = json[KEY_START_FROM_SPECIAL_PRICE] as? Double {
            self.startFromSpecialPrice = startFromSpecialPrice
        } else if let startFromSpecialPrice = json[KEY_START_FROM_SPECIAL_PRICE] as? String {
            if startFromSpecialPrice.isNumber {
                self.startFromSpecialPrice = Double(startFromSpecialPrice)!
            }
        }
        if let startFromTotalDives = json[KEY_START_FROM_TOTAL_DIVES] as? Int {
            self.startFromTotalDives = Int32(startFromTotalDives)
        } else if let startFromTotalDives = json[KEY_START_FROM_TOTAL_DIVES] as? String  {
            if startFromTotalDives.isNumber {
                self.startFromTotalDives = Int32(startFromTotalDives)!
            }
        }
        if let startFromDays = json[KEY_START_FROM_DAYS] as? Double {
            self.startFromDays = Int32(startFromDays)
        } else if let startFromDays = json[KEY_START_FROM_DAYS] as? String {
            if startFromDays.isNumber {
                self.startFromDays = Int32(startFromDays)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        if let subtitle = self.subtitle {
            json[KEY_SUBTITLE] = subtitle
        }
        
        if let imageLogo = self.imageLogo {
            json[KEY_IMAGE_LOGO] = imageLogo
        }
        
        if let images = self.images, !images.isEmpty {
            json[KEY_IMAGES] = images
        }
        json[KEY_RATING] = self.rating
        if let contact = self.contact {
            json[KEY_CONTACT] = contact.serialized()
        }
        if let membership = self.membership {
            json[KEY_MEMBERSHIP] = membership.serialized()
        }
        json[KEY_STATUS] = Int(status)
        if let desc = self.diveDescription {
            json[KEY_DESCRIPTION] = desc
        }
        if let location = self.location {
            json[KEY_LOCATION] = location.serialized()
        }
        if let featuredImage = self.featuredImage {
            json[KEY_FEATURED_IMAGE] = featuredImage
        }
        if let nsset = self.categories, let categories = nsset.allObjects as? [NCategory] {
            var array: Array<[String: Any]> = []
            for category in categories {
                array.append(category.serialized())
            }
            json[KEY_CATEGORIES] = array
        }
        json[KEY_START_FROM_PRICE] = Int(self.startFromPrice)
        json[KEY_START_FROM_TOTAL_DIVES] = Int(self.startFromTotalDives)
        json[KEY_START_FROM_DAYS] = Int(self.startFromDays)
        
        return json
    }

}
