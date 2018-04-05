//
//  NDiveService+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NDiveService)
public class NDiveService: NSManagedObject {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_RATING = "rating"
    private let KEY_RATING_COUNT = "rating_count"
    private let KEY_CATEGORY = "category"
    private let KEY_FEATURED_IMAGE = "featured_image"
    private let KEY_DIVE_SPOTS = "dive_spot"
    private let KEY_DAYS = "days"
    private let KEY_TOTAL_DIVES = "total_dives"
    private let KEY_TOTAL_DAY = "total_day"
    private let KEY_TOTAL_DIVESPOTS = "total_divespot"
    private let KEY_VISITED = "visited"
    private let KEY_LICENSE = "license"
    private let KEY_MIN_PERSON = "min_person"
    private let KEY_MAX_PERSON = "max_person"
    private let KEY_SCHEDULE = "schedule"
    private let KEY_FACILITIES = "facilities"
    private let KEY_NORMAL_PRICE = "normal_price"
    private let KEY_SPECIAL_PRICE = "special_price"
    private let KEY_DIVE_CENTER = "dive_center"
    private let KEY_IMAGES = "images"
    private let KEY_DESCRIPTION = "description"
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        
        if let ratingCount = json[KEY_RATING_COUNT] as? Int {
            self.ratingCount = Int64(ratingCount)
        } else if let ratingCount = json[KEY_RATING_COUNT] as? String {
            if ratingCount.isNumber {
                self.ratingCount = Int64(ratingCount)!
            }
        }
        
        if let categoriesArray = json[KEY_CATEGORY] as? Array<[String: Any]>, !categoriesArray.isEmpty {
            for categoryJson in categoriesArray {
                var category: NCategory? = nil
                
                if let id = categoryJson["id"] as? String {
                    category = NCategory.getCategory(using: id)
                }
                if category == nil {
                    category = NCategory()
                }
                category!.parse(json: categoryJson)
                self.addToCategories(category!)
            }
        } else if let categoriesString = json[KEY_CATEGORY] as? String {
            do {
                let data = categoriesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let categoriesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for categoryJson in categoriesArray {
                    var category: NCategory? = nil
                    if let id = categoryJson["id"] as? String {
                        category = NCategory.getCategory(using: id)
                    }
                    if category == nil {
                        category = NCategory()
                    }
                    category!.parse(json: categoryJson)
                    self.addToCategories(category!)
                }
            } catch {
                print(error)
            }
        }
        self.featuredImage = json[KEY_FEATURED_IMAGE] as? String
        if let diveSpotsArray = json[KEY_DIVE_SPOTS] as? Array<[String: Any]>, !diveSpotsArray.isEmpty {
            for diveSpotJson in diveSpotsArray {
                var diveSpot: NDiveSpot? = nil
                if let id = diveSpotJson["id"] as? String {
                    diveSpot = NDiveSpot.getDiveSpot(using: id)
                }
                if diveSpot == nil {
                    diveSpot = NDiveSpot()
                }
                diveSpot!.parse(json: json)
                self.addToDivespots(diveSpot!)
            }
        }
        
        if let days = json[KEY_DAYS] as? Int {
            self.days = Int32(days)
        } else if let days = json[KEY_DAYS] as? String {
            if days.isNumber {
                self.days = Int32(days)!
            }
        }
        if let totalDives = json[KEY_TOTAL_DIVES] as? Int {
            self.totalDives = Int32(totalDives)
        } else if let totalDives = json[KEY_TOTAL_DIVES] as? String {
            if totalDives.isNumber {
                self.totalDives = Int32(totalDives)!
            }
        }
        if let totalDays = json[KEY_TOTAL_DAY] as? Int {
            self.totalDays = Int32(totalDays)
        } else if let totalDays = json[KEY_TOTAL_DAY] as? String {
            if totalDays.isNumber {
                self.totalDays = Int32(totalDays)!
            }
        }
        if let totalDiveSpots = json[KEY_DIVE_SPOTS] as? Int {
            self.totalDiveSpots = Int32(totalDiveSpots)
        } else if let totalDiveSpots = json[KEY_DIVE_SPOTS] as? String {
            if totalDiveSpots.isNumber {
                self.totalDiveSpots = Int32(totalDiveSpots)!
            }
        }
        if let visited = json[KEY_VISITED] as? Int {
            self.visited = Int64(visited)
        } else if let visited = json[KEY_VISITED] as? String {
            if visited.isNumber {
                self.visited = Int64(visited)!
            }
        }
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
        if let minPerson = json[KEY_MIN_PERSON] as? Int {
            self.minPerson = Int32(minPerson)
        } else if let minPerson = json[KEY_MIN_PERSON] as? String {
            if minPerson.isNumber {
                self.minPerson = Int32(minPerson)!
            }
        }
        if let maxPerson = json[KEY_MAX_PERSON] as? Int {
            self.maxPerson = Int32(maxPerson)
        } else if let maxPerson = json[KEY_MAX_PERSON] as? String {
            if maxPerson.isNumber {
                self.maxPerson = Int32(maxPerson)!
            }
        }
        if let minPerson = json[KEY_MIN_PERSON] as? Int {
            self.minPerson = Int32(minPerson)
        } else if let minPerson = json[KEY_MIN_PERSON] as? String {
            if minPerson.isNumber {
                self.minPerson = Int32(minPerson)!
            }
        }
        if let scheduleJson = json[KEY_SCHEDULE] as? [String: Any] {
            self.schedule = Schedule(json: scheduleJson)
        } else if let scheduleString = json[KEY_SCHEDULE] as? String {
            do {
                let data = scheduleString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let scheduleJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.schedule = Schedule(json: scheduleJson)
            } catch {
                print(error)
            }
        }
        if let facilitiesJson = json[KEY_FACILITIES] as? [String: Any] {
            self.facilities = Facilities(json: json)
        } else if let facilitesString = json[KEY_FACILITIES] as? String {
            do {
                let data = facilitesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let facilitiesJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.facilities = Facilities(json: json)
            } catch {
                print(error)
            }
        }
        if let normalPrice = json[KEY_NORMAL_PRICE] as? Double {
            self.normalPrice = normalPrice
        } else if let normalPrice = json[KEY_NORMAL_PRICE] as? String {
            if normalPrice.isNumber {
                self.normalPrice = Double(normalPrice)!
            }
        }
        if let specialPrice = json[KEY_SPECIAL_PRICE] as? Double {
            self.specialPrice = specialPrice
        } else if let specialPrice = json[KEY_SPECIAL_PRICE] as? String {
            if specialPrice.isNumber {
                self.specialPrice = Double(specialPrice)!
            }
        }
        if let diveCenterJson = json[KEY_DIVE_CENTER] as? [String: Any] {
            if let id = diveCenterJson["id"] as? String {
                self.divecenter = NDiveCenter.getDiveCenter(using: id)
            }
            if self.divecenter == nil {
                self.divecenter = NDiveCenter()
            }
            self.divecenter!.parse(json: diveCenterJson)
        } else if let diveCenterString = json[KEY_DIVE_CENTER] as? String {
            do {
                let data = diveCenterString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let diveCenterJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = diveCenterJson["id"] as? String {
                    self.divecenter = NDiveCenter.getDiveCenter(using: id)
                }
                if self.divecenter == nil {
                    self.divecenter = NDiveCenter()
                }
                self.divecenter!.parse(json: diveCenterJson)
            } catch {
                print(error)
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
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        json[KEY_RATING] = rating
        json[KEY_RATING_COUNT] = Int(rating)
        if let nsset = self.categories, let categories = nsset.allObjects as? [NCategory], !categories.isEmpty  {
            var array: Array<[String: Any]> = []
            for category in categories {
                array.append(category.serialized())
            }
            json[KEY_CATEGORY] = array
        }
        if let featuredImage = self.featuredImage {
            json[KEY_FEATURED_IMAGE] = featuredImage
        }
        if let nsset = self.divespots, let divespots = nsset.allObjects as? [NDiveSpot], !divespots.isEmpty {
            var array: Array<[String: Any]> = []
            for divespot in divespots {
                array.append(divespot.serialized())
            }
            json[KEY_DIVE_SPOTS] = array
        }
        json[KEY_DAYS] = Int(self.days)
        json[KEY_TOTAL_DIVES] = Int(self.totalDives)
        json[KEY_TOTAL_DAY] = Int(self.totalDays)
        json[KEY_TOTAL_DIVESPOTS] = Int(self.totalDiveSpots)
        json[KEY_VISITED] = Int(self.visited)
        json[KEY_LICENSE] = self.license
        json[KEY_MIN_PERSON] = Int(self.minPerson)
        json[KEY_MAX_PERSON] = Int(self.maxPerson)
        if let schedule = self.schedule {
            json[KEY_SCHEDULE] = schedule.serialized()
        }
        if let facilities = self.facilities {
            json[KEY_FACILITIES] = facilities.serialized()
        }
        json[KEY_NORMAL_PRICE] = normalPrice
        json[KEY_SPECIAL_PRICE] = specialPrice
        if let divecenter = self.divecenter {
            json[KEY_DIVE_CENTER] = divecenter.serialized()
        }
        if let images = self.images, !images.isEmpty {
            json[KEY_IMAGES] = images
        }
        if let desc = self.diveServiceDescription {
            json[KEY_DESCRIPTION] = desc
        }
        return json
    }
    
    static func getDiveService(using id: String) -> NDiveService? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NDiveService")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let diveServices = try managedContext.fetch(fetchRequest) as? [NDiveService]
            if let diveServices = diveServices, !diveServices.isEmpty {
                return diveServices.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
