//
//  DiveSpot.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class DiveSpot: NSObject, Parseable {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_IMAGES = "images"
    private let KEY_HIGHLIGHT = "highlight"
    private let KEY_GREAT_FOR = "great_for"
    private let KEY_DEPTH_MIN = "depth_min"
    private let KEY_DEPTH_MAX = "depth_max"
    private let KEY_VISIBILITY_MIN = "visibility_min"
    private let KEY_VISIBILITY_MAX = "visibility_max"
    private let KEY_CURRENT_STATUS = "current_status"
    private let KEY_SURFACE_CONDITION = "surface_condition"
    private let KEY_WATER_TEMPERATURE_MIN = "temperature_min"
    private let KEY_WATER_TEMPERATURE_MAX = "temperature_max"
    private let KEY_EXPERIENCE_MIN = "experience_min"
    private let KEY_EXPERIENCE_MAX = "experience_max"
    private let KEY_RECOMMENDED_STAY_MIN = "recommended_stay_min"
    private let KEY_RECOMMENDED_STAY_MAX = "recommended_stay_max"
    private let KEY_LOCATION = "location"
    private let KEY_RATING = "rating"
    private let KEY_SHORT_DESCRIPTION = "short_description"
    private let KEY_DESCRIPTION = "description"
    private let KEY_STATUS_ACTIVE = "status_active"

    var currentStatus: String?
    var depthMax: Double = 0
    var depthMin: Double = 0
    var diveSpotDescription: String?
    var diveSpotShortDescription: String?
    var featuredImage: String?
    var greatFor: String?
    var hightlight: String?
    var id: String?
    var images: [String]?
    var location: Location?
    var name: String?
    var rating: Double = 0
    var recomendedStayMax: Int = 0
    var recomendedStayMin: Int = 0
    var statusActive: Int = 0
    var surfaceCondition: String?
    var temperatureMax: Double = 0
    var temperatureMin: Double = 0
    var visibilityMax: Double = 0
    var visibiltyMin: Double = 0
    var experienceMax: NExperience?
    var experienceMin: NExperience?
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
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
        self.hightlight = json[KEY_HIGHLIGHT] as? String
        self.greatFor = json[KEY_GREAT_FOR] as? String
        if let depthMin = json[KEY_DEPTH_MIN] as? Double {
            self.depthMin = depthMin
        } else if let depthMin = json[KEY_DEPTH_MIN] as? String {
            if depthMin.isNumber {
                self.depthMin = Double(depthMin)!
            }
        }
        if let depthMax = json[KEY_DEPTH_MAX] as? Double {
            self.depthMax = depthMax
        } else if let depthMax = json[KEY_DEPTH_MAX] as? String {
            if depthMax.isNumber {
                self.depthMax = Double(depthMax)!
            }
        }
        if let visibilityMin = json[KEY_VISIBILITY_MIN] as? Double {
            self.visibiltyMin = visibilityMin
        } else if let visibilityMin = json[KEY_VISIBILITY_MIN] as? String {
            if visibilityMin.isNumber {
                self.visibiltyMin = Double(visibilityMin)!
            }
        }
        
        if let visibilityMax = json[KEY_VISIBILITY_MAX] as? Double {
            self.visibilityMax = visibilityMax
        } else if let visiblityMax = json[KEY_VISIBILITY_MAX] as? String {
            if visiblityMax.isNumber {
                self.visibilityMax = Double(visiblityMax)!
            }
        }
        self.currentStatus = json[KEY_CURRENT_STATUS] as? String
        self.surfaceCondition = json[KEY_SURFACE_CONDITION] as? String
        if let temperatureMax = json[KEY_WATER_TEMPERATURE_MAX] as? Double {
            self.temperatureMax = temperatureMax
        } else if let temperatureMax = json[KEY_WATER_TEMPERATURE_MAX] as? String {
            if temperatureMax.isNumber {
                self.temperatureMax = Double(temperatureMax)!
            }
        }
        if let temperatureMin = json[KEY_WATER_TEMPERATURE_MIN] as? Double {
            self.temperatureMin = temperatureMin
        } else if let temperatureMin = json[KEY_WATER_TEMPERATURE_MIN] as? String {
            if temperatureMin.isNumber {
                self.temperatureMin = Double(temperatureMin)!
            }
        }
        if let experienceMinJson = json[KEY_EXPERIENCE_MIN] as? [String: Any] {
            if let id = experienceMinJson["id"] as? String {
                self.experienceMin = NExperience.getExperience(using: id)
            }
            if self.experienceMin == nil {
                self.experienceMin = NExperience()
            }
            self.experienceMin!.parse(json: experienceMinJson)
        } else if let experienceMinString = json[KEY_EXPERIENCE_MIN] as? String {
            do {
                let data = experienceMinString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let experienceMinJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = experienceMinJson["id"] as? String {
                    self.experienceMin = NExperience.getExperience(using: id)
                }
                if self.experienceMin == nil {
                    self.experienceMin = NExperience()
                }
                self.experienceMin!.parse(json: experienceMinJson)
            } catch {
                print(error)
            }
        }
        if let experienceMaxJson = json[KEY_EXPERIENCE_MAX] as? [String: Any] {
            if let id = experienceMaxJson["id"] as? String {
                self.experienceMax = NExperience.getExperience(using: id)
            }
            if self.experienceMax == nil {
                self.experienceMax = NExperience()
            }
            self.experienceMax!.parse(json: experienceMaxJson)
        } else if let experienceMaxString = json[KEY_EXPERIENCE_MAX] as? String {
            do {
                let data = experienceMaxString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let experienceMaxJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                if let id = experienceMaxJson["id"] as? String {
                    self.experienceMax = NExperience.getExperience(using: id)
                }
                
                if self.experienceMax == nil {
                    self.experienceMax = NExperience()
                }
                
                self.experienceMax!.parse(json: experienceMaxJson)
            } catch {
                print(error)
            }
        }
        if let recomendedStayMin = json[KEY_RECOMMENDED_STAY_MIN] as? Int {
            self.recomendedStayMin = recomendedStayMin
        } else if let recomendedStayMin = json[KEY_RECOMMENDED_STAY_MIN] as? String {
            if recomendedStayMin.isNumber {
                self.recomendedStayMin = Int(recomendedStayMin)!
            }
        }
        
        if let recomendedStayMax = json[KEY_RECOMMENDED_STAY_MAX] as? Int {
            self.recomendedStayMax = recomendedStayMax
        } else if let recomendedStayMax = json[KEY_RECOMMENDED_STAY_MAX] as? String {
            if recomendedStayMax.isNumber {
                self.recomendedStayMax = Int(recomendedStayMax)!
            }
        }
        
        if let locationJson = json[KEY_LOCATION] as? [String: Any] {
            self.location = Location(json: locationJson)
        } else if let locationString = json[KEY_LOCATION] as? String {
            do {
                let data = locationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let locationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.location = Location(json: locationJson)
            } catch {
                print(error)
            }
        }
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        self.diveSpotShortDescription = json[KEY_SHORT_DESCRIPTION] as? String
        self.diveSpotDescription = json [KEY_DESCRIPTION] as? String
        if let statusActive = json[KEY_STATUS_ACTIVE] as? Int {
            self.statusActive = statusActive
        } else if let statusActive = json[KEY_STATUS_ACTIVE] as? String {
            if statusActive.isNumber {
                self.statusActive = Int(statusActive)!
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
        if let images = self.images, !images.isEmpty {
            json[KEY_IMAGES] = images
        }
        if let hightlight = self.hightlight {
            json[KEY_HIGHLIGHT] = hightlight
        }
        if let greatFor = self.greatFor {
            json[KEY_GREAT_FOR] = greatFor
        }
        
        json[KEY_DEPTH_MIN] = self.depthMin
        json[KEY_DEPTH_MAX] = self.depthMax
        json[KEY_VISIBILITY_MIN] = self.visibiltyMin
        json[KEY_VISIBILITY_MAX] = self.visibilityMax
        if let currentStatus = self.currentStatus {
            json[KEY_CURRENT_STATUS] = currentStatus
        }
        if let surfaceCondition = self.surfaceCondition {
            json[KEY_SURFACE_CONDITION] = surfaceCondition
        }
        json[KEY_WATER_TEMPERATURE_MIN] = self.temperatureMin
        json[KEY_WATER_TEMPERATURE_MAX] = self.temperatureMax
        if let experienceMin = self.experienceMin {
            json[KEY_EXPERIENCE_MIN] = experienceMin.serialized()
        }
        if let experienceMax = self.experienceMax {
            json[KEY_EXPERIENCE_MAX] = experienceMax.serialized()
        }
        json[KEY_RECOMMENDED_STAY_MIN] = Int(self.recomendedStayMin)
        json[KEY_RECOMMENDED_STAY_MAX] = Int(self.recomendedStayMax)
        if let location = self.location {
            json[KEY_LOCATION] = location.serialized()
        }
        json[KEY_RATING] = self.rating
        if let shortDesc = self.diveSpotShortDescription {
            json[KEY_SHORT_DESCRIPTION] = shortDesc
        }
        if let desc = self.diveSpotDescription {
            json[KEY_DESCRIPTION] = desc
        }
        json[KEY_STATUS_ACTIVE] = Int(self.statusActive)
        return json

    }
}
