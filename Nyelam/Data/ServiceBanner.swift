//
//  ServiceBanner.swift
//  Nyelam
//
//  Created by Bobi on 6/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

class ServiceBanner: Banner {
    private let KEY_SERVICE_ID = "service_id"
    private let KEY_SERVICE_NAME = "service_name"
    private let KEY_DATE = "date"
    private let KEY_LICENSE = "license"
    private let KEY_ECO_TRIP = "eco_trip"
    private let KEY_DO_TRIP = "do_trip"
    private let KEY_ORGANIZATION = "organization"
    private let KEY_LICENSE_TYPE = "license_type"
    
    var serviceId: String?
    var serviceName: String?
    var date: Date?
    var license: Bool = false
    var doTrip: Bool = false
    var ecotrip: Int?
    var masterOrganization: NMasterOrganization?
    var licenseType: NLicenseType?
    
    override init(json: [String : Any]) {
        super.init(json: json)
    }
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        self.serviceId = json[KEY_SERVICE_ID] as? String
        self.serviceName = json[KEY_SERVICE_NAME] as? String
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
        if let timestamp = json[KEY_DATE] as? Int {
            self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        } else if let timestamp = json[KEY_DATE] as? String {
            if timestamp.isNumber {
                self.date = Date(timeIntervalSince1970: TimeInterval(timestamp)!)
            }
        }
        if let ecotrip = json[KEY_ECO_TRIP] as? Bool {
            self.ecotrip = ecotrip.number
        } else if let ecotrip = json[KEY_ECO_TRIP] as? String {
            self.ecotrip = ecotrip.toBool.number
        }
        if let doTrip = json[KEY_DO_TRIP] as? Bool {
            self.doTrip = doTrip
        } else if let doTrip = json[KEY_DO_TRIP] as? String {
            self.doTrip = doTrip.toBool
        }
        if let organizationJson = json[KEY_ORGANIZATION] as? [String: Any] {
            if let id = organizationJson["id"] as? String {
                self.masterOrganization = NMasterOrganization.getOrganization(using: id)
            }
            if self.masterOrganization == nil {
                self.masterOrganization = NMasterOrganization.init(entity: NSEntityDescription.entity(forEntityName: "NMasterOrganization", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                self.masterOrganization!.parse(json: organizationJson)
            }
        } else if let organizationString = json[KEY_ORGANIZATION] as? String {
            do {
                let data = organizationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let organizationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = organizationJson["id"] as? String {
                    self.masterOrganization = NMasterOrganization.getOrganization(using: id)
                }
                if self.masterOrganization == nil {
                    self.masterOrganization = NMasterOrganization.init(entity: NSEntityDescription.entity(forEntityName: "NMasterOrganization", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                    self.masterOrganization!.parse(json: organizationJson)
                }
            } catch {
                print(error)
            }
        }
        if let licenseTypeJson = json[KEY_LICENSE_TYPE] as? [String: Any] {
            if let id = licenseTypeJson["id"] as? String {
                self.licenseType = NLicenseType.getLicenseType(using: id)
            }
            if self.licenseType == nil {
                self.licenseType = NLicenseType.init(entity: NSEntityDescription.entity(forEntityName: "NLicenseType", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                self.licenseType!.parse(json: licenseTypeJson)
            }
        } else if let licenseTypeString = json[KEY_LICENSE_TYPE] as? String {
            do {
                let data = licenseTypeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let licenseTypeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = licenseTypeJson["id"] as? String {
                    self.licenseType = NLicenseType.getLicenseType(using: id)
                }
                if self.licenseType == nil {
                    self.licenseType = NLicenseType.init(entity: NSEntityDescription.entity(forEntityName: "NLicenseType", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                    self.licenseType!.parse(json: licenseTypeJson)
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        
        if let serviceId = self.serviceId {
            json[KEY_SERVICE_ID] = serviceId
        }
        if let date = self.date {
            json[KEY_DATE] = date.timeIntervalSince1970
        }
        if let serviceName = self.serviceName {
            json[KEY_SERVICE_NAME ] = serviceName
        }
        if let ecotrip = self.ecotrip {
            json[KEY_ECO_TRIP] = ecotrip
        }
        if let organization = self.masterOrganization {
            json[KEY_ORGANIZATION] = organization.serialized()
        }
        if let licenseType = self.licenseType {
            json[KEY_LICENSE_TYPE] = licenseType.serialized()
        }
        json[KEY_LICENSE] = self.license
        json[KEY_DO_TRIP] =  self.doTrip
        return json
    }
}
