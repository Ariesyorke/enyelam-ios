//
//  SearchService.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

public class SearchResultService: SearchResult {
    private let KEY_LICENSE = "license"
    private let KEY_ORGANIZATION = "organization"
    private let KEY_LICENSE_TYPE = "license_type"
    
    var license: Bool = false
    var organization: NMasterOrganization?
    var licenseType: NLicenseType?
    
    override init() {
        super.init()
    }
    
    override init(json: [String: Any]) {
        super.init(json: json)
        self.parse(json: json)
    }
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        if let license = json[KEY_LICENSE] as? Bool {
            self.license = license
        } else if let license = json[KEY_LICENSE] as? String {
            self.license = license.toBool
        }
        if let organizationJson = json[KEY_ORGANIZATION] as? [String: Any] {
            if let id = organizationJson["id"] as? String {
                self.organization = NMasterOrganization.getOrganization(using: id)
            }
            if self.organization == nil {
                self.organization =  NSEntityDescription.insertNewObject(forEntityName: "NMasterOrganization", into: AppDelegate.sharedManagedContext) as! NMasterOrganization
                
            }
            self.organization!.parse(json: organizationJson)
        } else if let organizationString = json[KEY_ORGANIZATION] as? String {
            do {
                let data = organizationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let organizationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = organizationJson["id"] as? String {
                    self.organization = NMasterOrganization.getOrganization(using: id)
                }
                if self.organization == nil {
                    self.organization =  NSEntityDescription.insertNewObject(forEntityName: "NMasterOrganization", into: AppDelegate.sharedManagedContext) as! NMasterOrganization
                    
                }
                self.organization!.parse(json: organizationJson)
            } catch {
                print(error)
            }
        }
        if let licenseTypeJson = json[KEY_LICENSE_TYPE] as? [String:Any] {
            if let id = licenseTypeJson["id"] as? String {
                self.licenseType = NLicenseType.getLicenseType(using: id)
            }
            if self.licenseType == nil {
                self.licenseType = NSEntityDescription.insertNewObject(forEntityName: "NLicenseType", into: AppDelegate.sharedManagedContext) as! NLicenseType
                
            }
            self.licenseType!.parse(json: licenseTypeJson)
        } else if let licenseTypeString = json[KEY_LICENSE_TYPE] as? String {
            do {
                let data = licenseTypeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let licenseTypeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = licenseTypeJson["id"] as? String {
                    self.licenseType = NLicenseType.getLicenseType(using: id)
                }
                if self.licenseType == nil {
                    self.licenseType = NSEntityDescription.insertNewObject(forEntityName: "NLicenseType", into: AppDelegate.sharedManagedContext) as! NLicenseType
                    
                }
                self.licenseType!.parse(json: licenseTypeJson)
            } catch {
                print(error)
            }
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        json[KEY_LICENSE] = license
        if let organization = self.organization {
            json[KEY_ORGANIZATION] = organization.serialized()
        }
        if let licenseType = self.licenseType {
            json[KEY_LICENSE_TYPE] = licenseType.serialized()
        }
        return json
    }
}
