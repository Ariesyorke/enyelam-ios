//
//  CoreDataModel+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

//
//  NCoreParser.swift
//  Nyelam
//
//  Created by Bobi on 4/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

extension NCategory {
    func parse(json: [String : Any]) {
        self.id = json["id"] as? String
        self.name = json["name"] as? String
        self.icon = json["icon"] as? String
        if self.icon == nil {
            json["image_url"] as? String
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json["id"] = id
        }
        if let name = self.name {
            json["name"] = name
        }
        if let icon = self.icon {
            json["icon"] = icon
        }
        return json
    }
    
    static func getCategories() -> [NCategory]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCategory")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let categories = try managedContext.fetch(fetchRequest) as? [NCategory]
            if let categories = categories, !categories.isEmpty {
                return categories
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getCategory(using id: String) -> NCategory? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCategory")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let categories = try managedContext.fetch(fetchRequest) as? [NCategory]
            if let categories = categories, !categories.isEmpty {
                return categories.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NUser {
    func parse(json: [String : Any]) {
        if let id = json["user_id"] as? String {
            self.id = id
        } else if let id = json["id"] as? String {
            self.id = id
        }
        if let fullname = json["fullname"] as? String {
            self.fullname = fullname
        }
        if let lastname = json["lastname"] as? String {
            self.lastName = lastname
        }
        if let firstname = json["firstname"] as? String {
            self.firstName = firstname
        }
        if let phone = json["phone_number"] as? String {
            self.phone = phone
        }
        if let email = json["email"] as? String {
            self.email = email
        }
        if let gender = json["gender"] as? String {
            self.gender = gender
        }
        if let picture = json["picture"] as? String {
            self.picture = picture
        }
        if let about = json["about"] as? String {
            self.about = about
        }
        
        if let isVerified = json["is_verified"] as? Bool {
            self.isVerified = isVerified
        } else if let isVerified = json["is_verified"] as? String {
            self.isVerified = isVerified.toBool
        }
        if let referralCode = json["referral_code"] as? String {
            self.referralCode = referralCode
        }
        if let address = json["address"] as? String {
            self.address = address
        }
        if let birthPlace = json["birthplace"] as? String {
            self.birthPlace = birthPlace
        }
        if let birthDateTimeStamp = json["birthdate"] as? Double {
            self.birthDate = NSDate(timeIntervalSince1970: birthDateTimeStamp)
        } else if let birthDateTimeStamp = json["birthdate"] as? String {
            if birthDateTimeStamp.isNumber {
                let timestamp = Double(birthDateTimeStamp)!
                self.birthDate = NSDate(timeIntervalSince1970: timestamp)
            }
        }
        if let certificateNumber = json["certificate_number"] as? String {
            self.certificateNumber = certificateNumber
        }
        if let certificateTimeStamp = json["certificate_date"] as? Double {
            self.certificateDate = NSDate(timeIntervalSince1970: certificateTimeStamp)
        } else if let certificateTimestamp = json["certificate_date"] as? String {
            if certificateTimestamp.isNumber {
                let timestamp = Double(certificateTimestamp)!
                self.certificateDate = NSDate(timeIntervalSince1970: timestamp)
            }
        }
        if let username = json["username"] as? String {
            self.username = username
        }
        if let cover = json["cover"] as? String {
            self.cover = cover
        }
        if let countryCodeJson = json["country_code"] as? [String: Any] {
            if let id = countryCodeJson["id"] as? String {
                self.countryCode = NCountryCode.getCountryCode(using: id)
            }
            if self.countryCode == nil {
                self.countryCode = NSEntityDescription.insertNewObject(forEntityName: "NCountryCode", into: AppDelegate.sharedManagedContext) as! NCountryCode

            }
            self.countryCode!.parse(json: countryCodeJson)
        } else if let countryCodeString = json["country_code"] as? String {
            do {
                let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryCodeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryCodeJson["id"] as? String {
                    self.countryCode = NCountryCode.getCountryCode(using: id)
                }
                if self.countryCode == nil {
                    self.countryCode = NSEntityDescription.insertNewObject(forEntityName: "NCountryCode", into: AppDelegate.sharedManagedContext) as! NCountryCode                }
                self.countryCode!.parse(json: countryCodeJson)
            } catch {
                print(error)
            }
        }
        if let countryJson = json["country"] as? [String: Any] {
            if let id = countryJson["id"] as? String {
                self.country = NCountry.getCountry(using: id)
            }
            if self.country == nil {
                self.country = NSEntityDescription.insertNewObject(forEntityName: "NCountry", into: AppDelegate.sharedManagedContext) as! NCountry
            }
            self.country!.parse(json: countryJson)
        } else if let countryString = json["country"] as? String {
            do {
                let data = countryString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryJson["id"] as? String {
                    self.country = NCountry.getCountry(using: id)
                }
                if self.country == nil {
                    self.country = NSEntityDescription.insertNewObject(forEntityName: "NCountry", into: AppDelegate.sharedManagedContext) as! NCountry
                }
                self.country!.parse(json: countryJson)
            } catch {
                print(error)
            }
        }
        if let socialMediaArray = json["social_media"] as? Array<[String: Any]>, !socialMediaArray.isEmpty {
            for socialMediaJson in socialMediaArray {
                var socialMedia: NSocialMedia? = nil
                if let id = socialMediaJson["id"] as? String, let type = socialMediaJson["type"] as? String {
                    socialMedia = NSocialMedia.getSocialMedia(using: id, and: type)
                }
                if socialMedia == nil {
                    socialMedia = NSEntityDescription.insertNewObject(forEntityName: "NSocialMedia", into: AppDelegate.sharedManagedContext) as! NSocialMedia

                }
                socialMedia!.parse(json: socialMediaJson)
                self.addToSocialMedias(socialMedia!)
            }
        } else if let socialMediaSring = json["social_media"] as? String {
            do {
                let data = socialMediaSring.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let socialMediaArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for socialMediaJson in socialMediaArray {
                    var socialMedia: NSocialMedia? = nil
                    if let id = socialMediaJson["id"] as? String, let type = socialMediaJson["type"] as? String {
                        socialMedia = NSocialMedia.getSocialMedia(using: id, and: type)
                    }
                    if socialMedia == nil {
                        socialMedia = NSEntityDescription.insertNewObject(forEntityName: "NSocialMedia", into: AppDelegate.sharedManagedContext) as! NSocialMedia
                    }
                    socialMedia!.parse(json: socialMediaJson)
                    self.addToSocialMedias(socialMedia!)
                }
            } catch {
                print(error)
            }
        }
        if let languageJson = json["language"] as? [String: Any] {
            if let id = languageJson["id"] as? String {
                self.language = NLanguage.getLanguage(using: id)
            }
            if self.language == nil {
                self.language = NSEntityDescription.insertNewObject(forEntityName: "NLanguage", into: AppDelegate.sharedManagedContext) as! NLanguage

            }
            self.language!.parse(json: languageJson)
        } else if let languageString = json["language"] as? String {
            do {
                let data = languageString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let languageJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = languageJson["id"] as? String {
                    self.language = NLanguage.getLanguage(using: id)
                }
                if self.language == nil {
                    self.language = NSEntityDescription.insertNewObject(forEntityName: "NLanguage", into: AppDelegate.sharedManagedContext) as! NLanguage
                }
                self.language!.parse(json: languageJson)
            } catch {
                print(error)
            }
        }
        if let nationalityJson = json["nationality"] as? [String: Any] {
            if let id = nationalityJson["id"] as? String {
                self.nationality = NNationality.getNationality(using: id)
            }
            if self.nationality == nil {
                self.nationality = NSEntityDescription.insertNewObject(forEntityName: "NNationality", into: AppDelegate.sharedManagedContext) as! NNationality
            }
            self.nationality!.parse(json: nationalityJson)
        } else if let nationalityString = json["nationality"] as? String {
            do {
                let data = nationalityString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let nationalityJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = nationalityJson["id"] as? String {
                    self.nationality = NNationality.getNationality(using: id)
                }
                if self.nationality == nil {
                    self.nationality = NSEntityDescription.insertNewObject(forEntityName: "NNationality", into: AppDelegate.sharedManagedContext) as! NNationality
                }
                self.nationality!.parse(json: nationalityJson)
            } catch {
                print(error)
            }
        }
        if let countryCodeJson = json["country_code"] as? [String: Any] {
            if let id = countryCodeJson["id"] as? String {
                self.countryCode = NCountryCode.getCountryCode(using: id)
            }
            if self.countryCode == nil {
                self.countryCode = NSEntityDescription.insertNewObject(forEntityName: "NCountryCode", into: AppDelegate.sharedManagedContext) as! NCountryCode
            }
            self.countryCode!.parse(json: countryCodeJson)
        } else if let countryCodeString = json["country_code"] as? String {
            do {
                let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryCodeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryCodeJson["id"] as? String {
                    self.countryCode = NCountryCode.getCountryCode(using: id)
                }
                if self.countryCode == nil {
                    self.countryCode = NSEntityDescription.insertNewObject(forEntityName: "NCountryCode", into: AppDelegate.sharedManagedContext) as! NCountryCode
                }
                self.countryCode!.parse(json: countryCodeJson)
            } catch {
                print(error)
            }
        }
        if let organizationJson = json["certificate_organization"] as? [String: Any] {
            if let id = organizationJson["id"] as? String {
                self.organization = NMasterOrganization.getOrganization(using: id)
            }
            if self.organization == nil {
                self.organization = NSEntityDescription.insertNewObject(forEntityName: "NMasterOrganization", into: AppDelegate.sharedManagedContext) as! NMasterOrganization
            }
            self.organization!.parse(json: organizationJson)
        } else if let organizationString = json["certificate_organization"] as? String {
            do {
                let data = organizationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let organizationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = organizationJson["id"] as? String {
                    self.organization = NMasterOrganization.getOrganization(using: id)
                }
                if self.organization == nil {
                    self.organization = NSEntityDescription.insertNewObject(forEntityName: "NMasterOrganization", into: AppDelegate.sharedManagedContext) as! NMasterOrganization
                }
                self.organization!.parse(json: organizationJson)
            } catch {
                print(error)
            }
        }
        if let licenseTypeJson = json["certificate_diver"] as? [String:Any] {
            if let id = licenseTypeJson["id"] as? String {
                self.licenseType = NLicenseType.getLicenseType(using: id)
            }
            if self.licenseType == nil {
                self.licenseType = NSEntityDescription.insertNewObject(forEntityName: "NLicenseType", into: AppDelegate.sharedManagedContext) as! NLicenseType
            }
            self.licenseType!.parse(json: licenseTypeJson)
        } else if let licenseTypeString = json["certificate_diver"] as? String {
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
        if let languageArray = json["languages"] as? Array<[String: Any]>, !languageArray.isEmpty {
            for languageJson in languageArray {
                var l: NLanguage? = nil
                if let id = languageJson["id"] as? String {
                    l = NLanguage.getLanguage(using: id)
                }
                if l == nil {
                    l = NSEntityDescription.insertNewObject(forEntityName: "NLanguage", into: AppDelegate.sharedManagedContext) as! NLanguage
                }
                l!.parse(json: languageJson)
                self.addToLanguages(l!)
            }
        } else if let languagesString = json["languages"] as? String {
            do {
                let data = languagesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let languageArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for languageJson in languageArray {
                    var l: NLanguage? = nil
                    if let id = languageJson["id"] as? String {
                        l = NLanguage.getLanguage(using: id)
                    }
                    if l == nil {
                        l = NSEntityDescription.insertNewObject(forEntityName: "NLanguage", into: AppDelegate.sharedManagedContext) as! NLanguage
                    }
                    l!.parse(json: languageJson)
                    self.addToLanguages(l!)
                }
            } catch {
                print(error)
            }
        }
        if let specialAbilities = json["special_abilities"] as? [String], !specialAbilities.isEmpty {
            self.specialAbilities = specialAbilities
        } else if let specialAbilitiesString = json["special_abilities"] as? String {
            do {
                let data = specialAbilitiesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let specialAbilities: Array<String> = try JSONSerialization.jsonObject(with: data!, options: []) as! [String]
                self.specialAbilities = specialAbilities
            } catch {
                print(error)
            }
        }

    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json["user_id"] = id
        }
        if let fullname = self.fullname {
            json["fullname"] = fullname
        }
        if let firstName = self.firstName {
            json["firstname"] = firstName
        }
        if let lastName = self.lastName {
            json["lastname"] = lastName
        }
        if let phoneNumber = self.phone {
            json["phone_number"] = phoneNumber
        }
        if let email = self.email {
            json["email"] = email
        }
        if let gender = self.gender {
            json["gender"] = gender
        }
        json["is_verified"] = self.isVerified
        if let referralCode = self.referralCode {
            json["referral_code"] = referralCode
        }
        if let address = self.address {
            json["address"] = address
        }
        if let birthPlace = self.birthPlace {
            json["birthplace"] = birthPlace
        }
        if let birthDate = self.birthDate {
            json["birthdate"] = birthDate.timeIntervalSince1970
        }
        if let certificateNumber = self.certificateNumber {
            json["certificate_number"] = certificateNumber
        }
        if let certificateDate = self.certificateDate {
            json["certificate_date"] = certificateDate.timeIntervalSince1970
        }
        if let userName = self.username {
            json["username"] = userName
        }
        if let cover = self.cover {
            json["cover"] = cover
        }
        if let nsset = self.socialMedias, let socialMedias = nsset.allObjects as? [NSocialMedia] {
            var array: Array<[String: Any]> = []
            for socialMedia in socialMedias {
                array.append(socialMedia.serialized())
            }
            json["social_media"] = array
        }
        if let country = self.country {
            json["country"] = country.serialized()
        }
        if let nationality = self.nationality {
            json["nationality"] = nationality.serialized()
        }
        if let language = self.language {
            json["language"] = language.serialized()
        }
        if let picture = self.picture {
            json["picture"] = picture
        }
        if let countryCode = self.countryCode {
            json["country_code"] = countryCode.serialized()
        }
        if let nsset = self.languages,
            let languages = nsset.allObjects as? [NLanguage] {
            var array: Array<[String: Any]> = []
            for language in languages {
                array.append(language.serialized())
            }
            json["languages"] = array
        }
        if let specialAbilities = self.specialAbilities, !specialAbilities.isEmpty {
            json["special_abilities"] = specialAbilities
        }
        if let about = self.about {
            json["about"] = about
        }
        return json
    }
    
    static func getUser(using id: String) -> NUser? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NUser")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let users = try managedContext.fetch(fetchRequest) as? [NUser]
            if let users = users, !users.isEmpty {
                return users.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
}

extension NAuthReturn {
    private var KEY_TOKEN: String {
        return "token"
    }
    private var KEY_USER: String {
        return "user"
    }
    
    func parse(json: [String : Any]) {
        self.token = json[KEY_TOKEN] as? String
        if let userJson = json[KEY_USER] as? [String: Any] {
            if let id = userJson["user_id"] as? String {
                self.user = NUser.getUser(using: id)
            }
            if self.user == nil {
                self.user = NSEntityDescription.insertNewObject(forEntityName: "NUser", into: AppDelegate.sharedManagedContext) as! NUser
            }
            self.user!.parse(json: userJson)
        } else if let userString = json[KEY_USER] as? String {
            do {
                let data = userString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let userJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = userJson["user_id"] as? String {
                    self.user = NUser.getUser(using: id)
                }
                if self.user == nil {
                    self.user = NSEntityDescription.insertNewObject(forEntityName: "NUser", into: AppDelegate.sharedManagedContext) as! NUser
                }
                self.user!.parse(json: userJson)
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let token = self.token {
            json[KEY_TOKEN] = token
        }
        if let user = self.user {
            json[KEY_USER] = user
        }
        return json
    }
    
    static func authUser() -> NAuthReturn? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NAuthReturn")
        do {
            let authReturns = try managedContext.fetch(fetchRequest) as? [NAuthReturn]
            if let authReturns = authReturns, !authReturns.isEmpty {
                return authReturns.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func deleteAllAuth() -> Bool {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NAuthReturn")
        do {
            let authReturns = try managedContext.fetch(fetchRequest) as? [NAuthReturn]
            if let authReturns = authReturns, !authReturns.isEmpty {
                for authReturn in authReturns {
                    managedContext.delete(authReturn)
                }
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
}

extension NCountry {
    
    func parse(json: [String : Any]) {
        self.id = json["id"] as? String
        self.name = json["name"] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json["id"] = id
        }
        if let name = self.name {
            json["name"] = name
        }
        return json
    }
    
    static func getCountries() -> [NCountry]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountry")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let countries = try managedContext.fetch(fetchRequest) as? [NCountry]
            if let countries = countries, !countries.isEmpty {
                return countries
            }
        } catch {
            print(error)
        }
        return nil
    }
    static func getCountryPosition(by id: String) -> Int {
        if let countries = getCountries(), !countries.isEmpty {
            var position = 0
            for country in countries {
                if country.id! == id {
                    return position
                }
                position += 1
            }
        }
        return 0
    }
    
    static func getCountry(using id: String) -> NCountry? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountry")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countries = try managedContext.fetch(fetchRequest) as? [NCountry]
            if let countries = countries, !countries.isEmpty {
                return countries.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
}

extension NExperience {
    private var KEY_ID: String {
        return "id"
    }
    private var KEY_NAME: String {
        return "name"
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        return json
        
    }
    static func getExperience(using id: String) -> NExperience? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NExperience")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let experiences = try managedContext.fetch(fetchRequest) as? [NExperience]
            if let experiences = experiences, !experiences.isEmpty {
                return experiences.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NCountryCode {
    private var KEY_ID: String { return "id" }
    private var KEY_COUNTRY_CODE: String { return "country_code" }
    private var KEY_COUNTRY_NAME: String { return "country_name" }
    private var KEY_COUNTRY_NUMBER: String { return "country_number" }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.countryCode = json[KEY_COUNTRY_CODE] as? String
        self.countryName = json[KEY_COUNTRY_NAME] as? String
        self.countryNumber = json[KEY_COUNTRY_NUMBER] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let countryCode = self.countryCode {
            json[KEY_COUNTRY_CODE] = countryCode
        }
        if let countryName = self.countryName {
            json[KEY_COUNTRY_NAME] = countryName
        }
        if let countryNumber = self.countryNumber {
            json[KEY_COUNTRY_NUMBER] = countryNumber
        }
        
        return json
    }
    
    static func getCountryCodes()->[NCountryCode]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        let sortDescriptor = NSSortDescriptor(key: "countryName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "id != nil && countryName != nil")
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                return countryCodes
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getCountryCode(using id: String) -> NCountryCode? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                return countryCodes.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    static func getPosition(by regionCode: String) -> Int {
        if let countryCodes = self.getCountryCodes(), !countryCodes.isEmpty {
            var position = 0
            for countryCode in countryCodes {
                if countryCode.countryCode == regionCode {
                    return position
                }
                position += 1
            }
        }
        return 0
    }
    
    
    static func getCountryCode(by regionCode: String) -> NCountryCode? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "countryCode == %@", regionCode)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                return countryCodes.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getCountryCode(with id: String) -> NCountryCode? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                return countryCodes.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    static func deleteCountryCode(by id: String) -> Bool {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCountryCode")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let countryCodes = try managedContext.fetch(fetchRequest) as? [NCountryCode]
            if let countryCodes = countryCodes, !countryCodes.isEmpty {
                let countryCode = countryCodes.first!
                managedContext.delete(countryCode)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
}

extension NLanguage {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        return json
    }
    static func getLanguage(using id: String) -> NLanguage? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NLanguage")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let languages = try managedContext.fetch(fetchRequest) as? [NLanguage]
            if let languages = languages, !languages.isEmpty {
                return languages.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getPosition(by id: String) -> Int {
        if let languages = getLanguages(), !languages.isEmpty {
            var position = 0
            for language in languages {
                if language.id! == id {
                    return position
                }
                position += 1
            }
        }
        return 0
    }
    
    static func getLanguages() -> [NLanguage]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NLanguage")
        fetchRequest.predicate = NSPredicate(format: "id != nil && name != nil")
        do {
            let languages = try managedContext.fetch(fetchRequest) as? [NLanguage]
            if let languages = languages, !languages.isEmpty {
                return languages
            }
        } catch {
            print(error)
        }
        return nil
        
    }
}

extension NDiveService {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    private var KEY_RATING: String { return "rating" }
    private var KEY_RATING_COUNT: String { return "rating_count" }
    private var KEY_CATEGORY: String { return "category" }
    private var KEY_FEATURED_IMAGE: String { return "featured_image" }
    private var KEY_DIVE_SPOTS: String { return "dive_spot" }
    private var KEY_DAYS: String { return "days" }
    private var KEY_TOTAL_DIVES: String { return "total_dives" }
    private var KEY_TOTAL_DAY: String { return "total_day" }
    private var KEY_TOTAL_DIVESPOTS: String { return "total_divespot" }
    private var KEY_VISITED: String { return "visited" }
    private var KEY_LICENSE: String { return "license" }
    private var KEY_MIN_PERSON: String { return "min_person" }
    private var KEY_MAX_PERSON: String { return "max_person" }
    private var KEY_SCHEDULE: String { return "schedule" }
    private var KEY_FACILITIES: String { return "facilities" }
    private var KEY_NORMAL_PRICE: String { return "normal_price" }
    private var KEY_SPECIAL_PRICE: String { return "special_price" }
    private var KEY_DIVE_CENTER: String { return "dive_center" }
    private var KEY_IMAGES: String { return "images" }
    private var KEY_DESCRIPTION: String { return "description" }
    private var KEY_AVAILABILITY_STOCK: String { return "availability_stock" }
    private var KEY_DAY_ON_SITE: String {return "day_on_site"}
    private var KEY_ORGANIZATION: String {return "organization"}
    private var KEY_LICENSE_TYPE: String {return "license_type"}
    private var KEY_OPEN_WATER: String {return "open_water"}
    
    func parse(json: [String : Any]) {
        if let id = json[KEY_ID] as? String {
            self.id = id
        } else if let id = json[KEY_ID] as? Int {
            self.id = String(id)
        }
        if let name = json[KEY_NAME] as? String {
            self.name = name
        }
        if let diveServiceDecription = json[KEY_DESCRIPTION] as? String {
            self.diveServiceDescription = diveServiceDecription
        }
        
        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        if let stock = json[KEY_AVAILABILITY_STOCK] as? Int {
            self.availability = Int32(stock)
        } else if let stock = json[KEY_AVAILABILITY_STOCK] as? String {
            if stock.isNumber {
                self.availability = Int32(stock)!
            }
        }
        
        if let ratingCount = json[KEY_RATING_COUNT] as? Int {
            self.ratingCount = Int64(ratingCount)
        } else if let ratingCount = json[KEY_RATING_COUNT] as? String {
            if ratingCount.isNumber {
                self.ratingCount = Int64(ratingCount)!
            }
        }
        
        if let dayOnSite = json[KEY_DAY_ON_SITE] as? Int {
            self.dayOnSite = Int32(dayOnSite)
        } else if let dayOnSite = json[KEY_DAY_ON_SITE] as? String {
            if dayOnSite.isNumber {
                self.dayOnSite = Int32(dayOnSite)!
            }
        }
        if let categoriesArray = json[KEY_CATEGORY] as? Array<[String: Any]>, !categoriesArray.isEmpty {
            for categoryJson in categoriesArray {
                var category: NCategory? = nil
                
                if let id = categoryJson["id"] as? String {
                    category = NCategory.getCategory(using: id)
                }
                if category == nil {
                    category = NSEntityDescription.insertNewObject(forEntityName: "NCategory", into: AppDelegate.sharedManagedContext) as! NCategory
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
                        category = NSEntityDescription.insertNewObject(forEntityName: "NCategory", into: AppDelegate.sharedManagedContext) as! NCategory
                    }
                    category!.parse(json: categoryJson)
                    self.addToCategories(category!)
                }
            } catch {
                print(error)
            }
        }
        self.featuredImage = json[KEY_FEATURED_IMAGE] as? String
        if self.shouldParseDivespot {
            if let diveSpotsArray = json[KEY_DIVE_SPOTS] as? Array<[String: Any]>, !diveSpotsArray.isEmpty {
                self.diveSpots = []
                for diveSpotJson in diveSpotsArray {
                    let diveSpot = DiveSpot(json: diveSpotJson)
                    self.diveSpots!.append(diveSpot)
                }
            } else if let diveSpotString = json[KEY_DIVE_SPOTS] as? String {
                self.diveSpots = []
                do {
                    let data = diveSpotString.data(using: String.Encoding.utf8,     allowLossyConversion: true)
                    let diveSpotsArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                    for diveSpotJson in diveSpotsArray {
                        let diveSpot = DiveSpot(json: diveSpotJson)
                        self.diveSpots!.append(diveSpot)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        if let days = json[KEY_DAYS] as? Int {
            self.days = Int32(days)
            self.totalDays = Int32(days)
        } else if let days = json[KEY_DAYS] as? String {
            if days.isNumber {
                self.days = Int32(days)!
                self.totalDays = Int32(days)!
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
        if self.shouldParseDivespot {
            if let facilitiesJson = json[KEY_FACILITIES] as? [String: Any] {
                self.facilities = Facilities(json: facilitiesJson)
            } else if let facilitesString = json[KEY_FACILITIES] as? String {
                do {
                    let data = facilitesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                    let facilitiesJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    self.facilities = Facilities(json: facilitiesJson)
                } catch {
                    print(error)
                }
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
                self.divecenter =  NSEntityDescription.insertNewObject(forEntityName: "NDiveCenter", into: AppDelegate.sharedManagedContext) as! NDiveCenter

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
                    self.divecenter = NSEntityDescription.insertNewObject(forEntityName: "NDiveCenter", into: AppDelegate.sharedManagedContext) as! NDiveCenter
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
        if let licenseTypeJson = json["license_type"] as? [String:Any] {
            if let id = licenseTypeJson["id"] as? String {
                self.licenseType = NLicenseType.getLicenseType(using: id)
            }
            if self.licenseType == nil {
                self.licenseType = NSEntityDescription.insertNewObject(forEntityName: "NLicenseType", into: AppDelegate.sharedManagedContext) as! NLicenseType
                
            }
            self.licenseType!.parse(json: licenseTypeJson)
        } else if let licenseTypeString = json["license_type"] as? String {
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
        if let openWater = json[KEY_OPEN_WATER] as? Bool {
            self.openWater = openWater
        } else if let openWater = json[KEY_OPEN_WATER] as? String {
            self.openWater = openWater.toBool
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
        if let description = self.diveServiceDescription {
            json[KEY_DESCRIPTION] = description
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
        
        if let divespots = self.diveSpots, !divespots.isEmpty {
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
        json[KEY_DAY_ON_SITE] = Int(dayOnSite)
        if let organization = self.organization {
            json[KEY_ORGANIZATION] = organization.serialized()
        }
        if let licenseType = self.licenseType {
            json[KEY_LICENSE_TYPE] = licenseType.serialized()
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


extension NOrder {
    private var KEY_ORDER_ID: String { return "order_id" }
    private var KEY_STATUS: String  { return "status" }
    private var KEY_ORDER_STATUS: String {return "order_status"}
    private var KEY_SCHEDULE: String { return "schedule" }
    private var KEY_CART: String { return "cart" }
    private var KEY_ADDITIONAL: String { return "additional" }
    private var KEY_EQUIPMENT_RENTS: String { return "equipment_rents" }
    private var KEY_SHIPPING_ADDRESS: String {return "shipping_address"}
    private var KEY_BILLING_ADDRESS: String {return "billing_address" }
    private var KEY_VERITRANS_TOKEN: String {return "veritrans_token"}
    private var KEY_PAYPAL_CURRENCY: String {return "paypal_currency"}
    
    func parse(json: [String : Any]) {
        if let veritransJson = json[KEY_VERITRANS_TOKEN] as? [String: Any] {
            if let id = veritransJson["token_id"] as? String {
                self.veritransToken = id
            }
        } else if let veritransString = json[KEY_VERITRANS_TOKEN] as? String {
            do {
                let data = veritransString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let veritransJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = veritransJson["token_id"] as? String {
                    self.veritransToken = id
                }
            } catch {
                print(error)
            }
        }
        if let paypalCurrencyJson = json[KEY_PAYPAL_CURRENCY] as? [String: Any] {
            self.paypalCurrency = PaypalCurrency(json: paypalCurrencyJson)
        } else if let paypalCurrencyString = json[KEY_PAYPAL_CURRENCY] as? String {
            do {
                let data = paypalCurrencyString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let paypalCurrencyJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.paypalCurrency = PaypalCurrency(json: paypalCurrencyJson)
            } catch {
                print(error)
            }
        }
        if let orderId = json[KEY_ORDER_ID] as? String {
            self.orderId = orderId
        } else if let orderId = json[KEY_ORDER_ID] as? Int {
            self.orderId = String(orderId)
        }
        if let status = json[KEY_STATUS] as? String {
            self.status = status
        } else if let status = json[KEY_ORDER_STATUS] as? String {
            self.status = status
        }
        if let schedule = json[KEY_SCHEDULE] as? Double {
            self.schedule = schedule
        } else if let schedule = json[KEY_SCHEDULE] as? String {
            if schedule.isNumber {
                self.schedule = Double(schedule)!
            }
        }
        if let cartJson = json[KEY_CART] as? [String: Any] {
            self.cart = Cart(json: cartJson)
        } else if let cartString = json[KEY_CART] as? String {
            do {
                let data = cartString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let cartJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.cart = Cart(json: cartJson)
            } catch {
                print(error)
            }
        }
        if let additionalArray = json[KEY_ADDITIONAL] as? Array<[String: Any]> {
            self.additionals = []
            for additionalJson in additionalArray {
                let additional = Additional(json: additionalJson)
                self.additionals!.append(additional)
            }
        } else if let additionalString = json[KEY_ADDITIONAL] as? String {
            do {
                let data = additionalString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let additionalArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.additionals = []
                for additionalJson in additionalArray {
                    let additional = Additional(json: additionalJson)
                    self.additionals!.append(additional)
                }
            } catch {
                print(error)
            }
        }
        
        if let equipmentArray = json[KEY_EQUIPMENT_RENTS] as? Array<[String: Any]> {
            self.equipments = []
            for equipmentJson in equipmentArray {
                let equipment = Equipment(json: equipmentJson)
                self.equipments!.append(equipment)
            }
        } else if let equipmentString = json[KEY_EQUIPMENT_RENTS] as? String {
            do {
                let data = equipmentString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let equipmentArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.equipments = []
                for equipmentJson in equipmentArray {
                    let equipment = Equipment(json: equipmentJson)
                    self.equipments!.append(equipment)
                }
            } catch {
                print(error)
            }
        }
        
        if let billingAddressJson = json[KEY_BILLING_ADDRESS] as? [String: Any] {
            if let id = billingAddressJson["address_id"] as? String {
                self.billingAddress = NAddress.getAddress(using: id)
            }
            if self.billingAddress == nil {
                self.billingAddress = NSEntityDescription.insertNewObject(forEntityName: "NAddress", into: AppDelegate.sharedManagedContext) as! NAddress
            }
            self.billingAddress!.parse(json: billingAddressJson)
        } else if let billingAddressString = json[KEY_BILLING_ADDRESS] as? String {
            do {
                let data = billingAddressString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let billingAddressJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = billingAddressJson["address_id"] as? String {
                    self.billingAddress = NAddress.getAddress(using: id)
                }
                if self.billingAddress == nil {
                    self.billingAddress = NSEntityDescription.insertNewObject(forEntityName: "NAddress", into: AppDelegate.sharedManagedContext) as! NAddress
                }
                self.billingAddress!.parse(json: billingAddressJson)
            } catch {
                print(error)
            }
        }
        
        if let shippingAddressJson = json[KEY_SHIPPING_ADDRESS] as? [String: Any] {
            if let id = shippingAddressJson["address_id"] as? String {
                self.shippingAddress = NAddress.getAddress(using: id)
            }
            if self.shippingAddress == nil {
                self.shippingAddress = NSEntityDescription.insertNewObject(forEntityName: "NAddress", into: AppDelegate.sharedManagedContext) as! NAddress
            }
            self.shippingAddress!.parse(json: shippingAddressJson)
        } else if let shippingAddressString = json[KEY_SHIPPING_ADDRESS] as? String {
            do {
                let data = shippingAddressString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let shippingAddressJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = shippingAddressJson["address_id"] as? String {
                    self.shippingAddress = NAddress.getAddress(using: id)
                }
                if self.shippingAddress == nil {
                    self.shippingAddress = NSEntityDescription.insertNewObject(forEntityName: "NAddress", into: AppDelegate.sharedManagedContext) as! NAddress
                }
                self.shippingAddress!.parse(json: shippingAddressJson)
            } catch {
                print(error)
            }
        }
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let orderId = self.orderId {
            json[KEY_ORDER_ID] = orderId
        }
        if let status = self.status {
            json[KEY_STATUS] = status
        }
        json[KEY_SCHEDULE] = self.schedule
        if let cart = self.cart {
            json[KEY_CART] = cart.serialized()
        }
        if let additionals = self.additionals, !additionals.isEmpty {
            var additionalArray: Array<[String: Any]> = []
            for additional in additionals {
                additionalArray.append(additional.serialized())
            }
            json[KEY_ADDITIONAL] = additionalArray
        }
        
        if let equipments = self.equipments, !equipments.isEmpty {
            var equipmentArray: Array<[String: Any]> = []
            for equipment in equipments {
                equipmentArray.append(equipment.serialized())
            }
            json[KEY_EQUIPMENT_RENTS] = equipmentArray
        }
        if let billingAddress = self.billingAddress {
            json[KEY_BILLING_ADDRESS] = billingAddress.serialized()
        }
        if let shippingAddress = self.shippingAddress {
            json[KEY_SHIPPING_ADDRESS] = shippingAddress.serialized()
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
    
    static func getOrder(using orderId: String) -> NOrder? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NOrder")
        fetchRequest.predicate = NSPredicate(format: "orderId == %@", orderId)
        do {
            let orders = try managedContext.fetch(fetchRequest) as? [NOrder]
            if let orders = orders, !orders.isEmpty {
                return orders.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NDiveCenter {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    private var KEY_SUBTITLE: String { return "subtitle" }
    private var KEY_IMAGE_LOGO: String { return "image_logo" }
    private var KEY_IMAGES: String { return "images" }
    private var KEY_RATING: String { return "rating" }
    private var KEY_CONTACT: String { return "contact" }
    private var KEY_MEMBERSHIP: String { return "membership" }
    private var KEY_STATUS: String { return "status" }
    private var KEY_DESCRIPTION: String { return "description" }
    private var KEY_LOCATION: String { return "location" }
    private var KEY_FEATURED_IMAGE: String { return "featured_image" }
    private var KEY_CATEGORIES: String { return  "categories" }
    private var KEY_START_FROM_PRICE: String { return "start_from_price" }
    private var KEY_START_FROM_SPECIAL_PRICE: String { return "start_from_special_price" }
    private var KEY_START_FROM_TOTAL_DIVES: String { return "start_from_total_dives" }
    private var KEY_START_FROM_DAYS: String { return "start_from_days" }
    private var KEY_LOCATIONS: String { return "locations" }
    
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
        if let id = json[KEY_ID] as? String {
            self.id = json[KEY_ID] as? String
        }
        if let name = json[KEY_NAME] as? String {
            self.name = name
        }
        if let subtitle = json[KEY_SUBTITLE] as? String {
            self.subtitle = subtitle
        }
        if let imageLogo = json[KEY_IMAGE_LOGO] as? String {
            self.imageLogo = imageLogo
        }
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
        if let desc = json[KEY_DESCRIPTION] as? String {
            self.diveDescription = json[KEY_DESCRIPTION] as? String
        }
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
                    category = NSEntityDescription.insertNewObject(forEntityName: "NCategory", into: AppDelegate.sharedManagedContext) as! NCategory
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
                        category = NSEntityDescription.insertNewObject(forEntityName: "NCategory", into: AppDelegate.sharedManagedContext) as! NCategory
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

extension NProvince {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String{ return "name" }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        return json
    }
    
    static func getProvince(using id: String) -> NProvince? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NProvince")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let provinces = try managedContext.fetch(fetchRequest) as? [NProvince]
            if let provinces = provinces, !provinces.isEmpty {
                return provinces.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NSocialMedia {
    private var KEY_TYPE: String { return "type" }
    private var KEY_ID: String { return "id" }
    
    func parse(json: [String : Any]) {
        self.type = json[KEY_TYPE] as? String
        self.id = json[KEY_ID] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let type = self.type {
            json[KEY_TYPE] = type
        }
        if let id = self.id {
            json[KEY_ID] = id
        }
        return json
    }
    
    static func getSocialMedia(using id: String, and type: String) -> NSocialMedia? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSocialMedia")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND type == %@", id, type)
        do {
            let socialMedias = try managedContext.fetch(fetchRequest) as? [NSocialMedia]
            if let socialMedias = socialMedias, !socialMedias.isEmpty {
                return socialMedias.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NCity {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        return json
    }
    
    static func getCity(using id: String) -> NCity? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NCity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let cities = try managedContext.fetch(fetchRequest) as? [NCity]
            if let cities = cities, !cities.isEmpty {
                return cities.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}

extension NNationality {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let name = self.name {
            json[KEY_NAME] = name
        }
        return json
    }
    
    static func getNationality(using id: String) -> NNationality? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NNationality")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let nationalities = try managedContext.fetch(fetchRequest) as? [NNationality]
            if let nationalities = nationalities, !nationalities.isEmpty {
                return nationalities.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NSummary {
    private var KEY_ORDER: String { return "order" }
    private var KEY_SERVICE: String { return "service" }
    private var KEY_CONTACT: String { return "contact" }
    private var KEY_PARTICIPANTS: String { return "participants" }
    
    static func deleteAllOrder() -> Bool {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSummary")
        do {
            let summaries = try managedContext.fetch(fetchRequest) as? [NSummary]
            if let summaries = summaries, !summaries.isEmpty {
                for summary in summaries {
                    managedContext.delete(summary)
                }
                return true
            }
        } catch {
            print(error)
        }
        return false
    }

    func parse(json: [String : Any]) {
        if let orderJson = json[KEY_ORDER] as? [String: Any] {
            if let orderId = orderJson["order_id"] as? String {
                self.order = NOrder.getOrder(using: orderId)
            }
            if self.order == nil {
                self.order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
            }
            self.order!.parse(json: orderJson)
            self.id = self.order!.orderId
        } else if let orderString = json[KEY_ORDER] as? String {
            do {
                let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let orderId = orderJson["order_id"] as? String {
                    self.order = NOrder.getOrder(using: orderId)
                }
                if self.order == nil {
                    self.order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
                }
                self.order!.parse(json: orderJson)
                self.id = self.order!.orderId
            } catch {
                print(error)
            }
        }
        if let serviceJson = json[KEY_SERVICE] as? [String: Any] {
            if let id = serviceJson["id"] as? String {
                self.diveService = NDiveService.getDiveService(using: id)
            }
            if self.diveService == nil {
                self.diveService = NSEntityDescription.insertNewObject(forEntityName: "NDiveService", into: AppDelegate.sharedManagedContext) as! NDiveService
            }
            self.diveService!.parse(json: serviceJson)
        } else if let serviceString = json[KEY_SERVICE] as? String {
            do {
                let data = serviceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let serviceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = serviceJson["id"] as? String {
                    self.diveService = NDiveService.getDiveService(using: id)
                }
                if self.diveService == nil {
                    self.diveService = NDiveService()
                }
                self.diveService!.parse(json: serviceJson)
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
        if let participantArray = json[KEY_PARTICIPANTS] as? Array<[String: Any]>, !participantArray.isEmpty {
            self.participant = []
            for participant in participantArray {
                self.participant!.append(Participant(json: participant))
            }
        } else if let participantString = json[KEY_PARTICIPANTS] as? String {
            do {
                let data = participantString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let participantArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.participant = []
                for participant in participantArray {
                    self.participant!.append(Participant(json: participant))
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let order = self.order {
            json[KEY_ORDER] = order.serialized()
        }
        if let service = self.diveService {
            json[KEY_SERVICE] = service.serialized()
        }
        if let contact = self.contact {
            json[KEY_CONTACT] = contact.serialized()
        }
        if let participants = self.participant, !participants.isEmpty {
            var array: Array<[String: Any]> = []
            for participant in participants {
                array.append(participant.serialized())
            }
            json[KEY_PARTICIPANTS] = array
        }
        return json
    }
    
    static func getSummary(using id: String) -> NSummary? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSummary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let summaries = try managedContext.fetch(fetchRequest) as? [NSummary]
            if let summaries = summaries, !summaries.isEmpty {
                return summaries.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}

extension NSearchResult {
    private var KEY_ID: String { return "id" }
    private var KEY_NAME: String { return "name" }
    private var KEY_RATING: String { return "rating" }
    private var KEY_TYPE: String { return "type" }
    private var KEY_COUNT: String { return "count" }
    private var KEY_PROVINCE: String { return "province" }
    private var KEY_LICENSE: String { return "license" }
    private var KEY_LICENSE_TYPE: String {return "license_type"}
    private var KEY_ORGANIZATION: String {return "organization"}
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
        self.province = json[KEY_PROVINCE] as? String

        if let rating = json[KEY_RATING] as? Double {
            self.rating = rating
        } else if let rating = json[KEY_RATING] as? String {
            if rating.isNumber {
                self.rating = Double(rating)!
            }
        }
        
        if let type = json[KEY_TYPE] as? Int {
            self.type = Int16(type)
        } else if let type = json[KEY_TYPE] as? String {
            if type.isNumber {
                self.type = Int16(type)!
            }
        }
        
        if let count = json[KEY_COUNT] as? Int {
            self.count = Int64(count)
        } else if let count = json[KEY_COUNT] as? String {
            if count.isNumber {
                self.count = Int64(count)!
            }
        }
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
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        if let province = self.province {
            json[KEY_PROVINCE] = province
        }
        json[KEY_LICENSE] = license
        json[KEY_RATING] = rating
        json[KEY_TYPE] = Int(type)
        json[KEY_COUNT] = Int(count)
        if let organization = self.organization {
            json[KEY_ORGANIZATION] = organization.serialized()
        }
        if let licenseType = self.licenseType {
            json[KEY_LICENSE_TYPE] = licenseType.serialized()
        }
        return json
    }

    static func getSavedResult(using id: String, and type: Int16)->NSearchResult? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSearchResult")
        fetchRequest.predicate = NSPredicate(format: "type == \(type) AND id == \(id)")
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSearchResult]
            if let results = results, !results.isEmpty {
                return results.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    static func getSavedResults(exceptionalType: Int16) -> [NSearchResult]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSearchResult")
//        let predicate = NSPredicate(format: "id != nil AND name != nil AND type > 0 AND type != %s", exceptionalType)
        let predicate = NSPredicate(format: "id != nil AND name != nil AND type != \(exceptionalType)")
        fetchRequest.predicate = predicate
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSearchResult]
            if let results = results, !results.isEmpty {
                return results
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NMasterOrganization: Parseable {
    private var KEY_ID: String {
        return "id"
    }
        
    private var KEY_NAME: String {
        return "name"
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        return json
    }
    
    static func getPosition(by id: String) -> Int {
        if let organizations = getOrganizations(), !organizations.isEmpty {
            var position = 0
            for organization in organizations {
                if organization.id! == id {
                    return position
                }
                position += 1
            }
        }
        return 0
    }

    
    static func getOrganization(using id: String)->NMasterOrganization? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NMasterOrganization")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NMasterOrganization]
            if let results = results, !results.isEmpty {
                return results.first
            }
        } catch {
            print(error)
        }
        return nil
    }

    static func getOrganizations() -> [NMasterOrganization]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NMasterOrganization")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "id != nil && name != nil")
        do {
            let organizations = try managedContext.fetch(fetchRequest) as? [NMasterOrganization]
            if let organizations = organizations, !organizations.isEmpty {
                return organizations
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NLicenseType: Parseable {
    private var KEY_ID: String  {
        return "id"
    }
    
    private var KEY_NAME: String {
        return "name"
    }
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        self.name = json[KEY_NAME] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        
        if let name = self.name {
            json[KEY_NAME] = name
        }
        
        return json
    }
    
    static func getLicenseType(using id: String)->NLicenseType? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NLicenseType")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NLicenseType]
            if let results = results, !results.isEmpty {
                return results.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}

extension NDistrict: Parseable {
    private var KEY_ID: String  {
        return "id"
    }
    
    private var KEY_NAME: String {
        return "name"
    }
    
    private var KEY_SUBDISTRICT_ID: String {
        return "subdistrict_id"
    }
    
    private var KEY_SUBDISTRICT_NAME: String {
        return "subdistrict_name"
    }
    
    func parse(json: [String : Any]) {
        if let id = json[KEY_ID] as? String {
            self.id = id
        } else if let id = json[KEY_SUBDISTRICT_ID] as? String {
            self.id = id
        }
        if let name = json[KEY_NAME] as? String {
            self.name = name
        } else if let name = json[KEY_SUBDISTRICT_NAME] as? String {
            self.name = name
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
        
        return json
    }
    
    static func getDistrict(using id: String)->NDistrict? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NDistrict")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NDistrict]
            if let results = results, !results.isEmpty {
                return results.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension NProduct: Parseable {
    private var KEY_ID: String  {
        return "id"
    }
    private var KEY_NAME: String {
        return "product_name"
    }
    private var KEY_FEATURED_IMAGE: String {
        return "featured_image"
    }
    private var KEY_IMAGES: String {
        return "images"
    }
    private var KEY_SPECIAL_PRICE: String {
        return "special_price"
    }
    private var KEY_NORMAL_PRICE: String {
        return "normal_price"
    }
    private var KEY_STATUS: String {
        return "status"
    }
    private var KEY_COLOR: String {
        return "color"
    }
    private var KEY_HEX_COLOR: String {
        return "hex_color"
    }
    private var KEY_SIZE: String {
        return "size"
    }
    private var KEY_CATEGORIES: String {
        return "categories"
    }
    private var KEY_VARIATIONS: String {
        return "variations"
    }
    private var KEY_DESCRIPTION: String {
        return "description"
    }
    
    static func getProduct(using id: String)->NProduct? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NProduct")
        fetchRequest.predicate = NSPredicate(format: "productId == %@", id)
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NProduct]
            if let results = results, !results.isEmpty {
                return results.first
            }
        } catch {
            print(error)
        }
        return nil
    }

    
    func parse(json: [String : Any]) {
        self.productId = json[KEY_ID] as? String
        self.productName = json[KEY_NAME] as? String
        self.featuredImage = json[KEY_FEATURED_IMAGE] as? String
        self.productDescription = json[KEY_DESCRIPTION] as? String
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
        if let specialPrice = json[KEY_SPECIAL_PRICE] as? Double {
            self.specialPrice = specialPrice
        } else if let specialPrice = json[KEY_SPECIAL_PRICE] as? String {
            if specialPrice.isNumber {
                self.specialPrice = Double(specialPrice)!
            }
        }
        if let normalPrice = json[KEY_NORMAL_PRICE] as? Double {
            self.normalPrice = normalPrice
        } else if let normalPrice = json[KEY_NORMAL_PRICE] as? String {
            if normalPrice.isNumber {
                self.normalPrice = Double(normalPrice)!
            }
        }
        self.color = json[KEY_COLOR] as? String
        self.status = json[KEY_STATUS] as? String
        
        if let categoriesArray = json[KEY_CATEGORIES] as? Array<[String: Any]>, !categoriesArray.isEmpty {
            for categoryJson in categoriesArray {
                var category: NProductCategory? = nil
                if let id = categoryJson["id"] as? String {
                    category = NProductCategory.getCategory(using: id)
                }
                if category == nil {
                    category = NSEntityDescription.insertNewObject(forEntityName: "NProductCategory", into: AppDelegate.sharedManagedContext) as! NProductCategory
                    category!.parse(json: categoryJson)
                }
                self.addToCategories(category!)
            }
        } else if let categoriesArrayString = json[KEY_CATEGORIES] as? String {
            do {
                let data = categoriesArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let categoriesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for categoryJson in categoriesArray {
                    var category: NProductCategory? = nil
                    if let id = categoryJson["id"] as? String {
                        category = NProductCategory.getCategory(using: id)
                    }
                    if category == nil {
                        category = NSEntityDescription.insertNewObject(forEntityName: "NProductCategory", into: AppDelegate.sharedManagedContext) as! NProductCategory
                        category!.parse(json: categoryJson)
                    }
                    self.addToCategories(category!)
                }
            } catch {
                print(error)
            }
        }
        if let variationJson = json[KEY_VARIATIONS] as? [String: Any] {
            self.variations = []
            for (key, _) in variationJson {
                var variation = Variation()
                variation.key = key
                variation.parse(json: variationJson)
                self.variations!.append(variation)
            }
            
        } else if let variationArrayString = json[KEY_VARIATIONS] as? String {
            do {
                let data = variationArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let variationJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.variations = []
                for (key, _) in variationJson {
                    var variation = Variation()
                    variation.key = key
                    variation.parse(json: variationJson)
                    self.variations!.append(variation)
                }
            } catch {
                print(error)
            }

        }
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let productId = self.productId {
            json[KEY_ID] = productId
        }
        if let productName = self.productName {
            json[KEY_NAME] = productName
        }
        if let featuredImage = self.featuredImage {
            json[KEY_FEATURED_IMAGE] = featuredImage
        }
        if let productDescription = self.productDescription {
            json[KEY_DESCRIPTION] = productDescription
        }
        if let images = self.images, !images.isEmpty {
            json[KEY_IMAGES] = images
        }
        json[KEY_SPECIAL_PRICE] = self.specialPrice
        json[KEY_NORMAL_PRICE] = self.normalPrice
        if let status = self.status {
            json[KEY_STATUS] = status
        }
        if let color = self.color {
            json[KEY_COLOR] = color
        }
        if let nsset = self.categories, let categories = nsset.allObjects as? [NCategory], !categories.isEmpty {
            var array: Array<[String: Any]> = []
            for category in categories {
                array.append(category.serialized())
            }
            json[KEY_CATEGORIES] = array
        }
        if let productDescription = self.productDescription {
            json[KEY_DESCRIPTION] = productDescription
        }
        if let variations = self.variations, !variations.isEmpty {
            var obj: [String: Any] = [:]
            for variation in variations {
                obj[variation.key!] = variation.serialized()[variation.key!]
            }
        }
        return json
    }
}

extension NAddress: Parseable {
    private var KEY_ADDRESS_ID: String {
        return "address_id"
    }
    
    private var KEY_FULLNAME: String {
        return "fullname"
    }
    
    private var KEY_ADDRESS: String {
        return "address"
    }
    
    private var KEY_ZIPCODE: String {
        return "zip_code"
    }
    
    private var KEY_PROVINCE: String {
        return "province"
    }
    
    private var KEY_CITY: String {
        return "city"
    }
    
    private var KEY_DISTRICT: String {
        return "district"
    }
    
    private var KEY_PHONE_NUMBER: String {
        return "phone_number"
    }
    
    private var KEY_DEFAULT_SHIPPING: String {
        return "default_shipping"
    }
    
    private var KEY_DEFAULT_BILLING: String {
        return "default_billing"
    }
    
    private var KEY_EMAIL: String {
        return "email"
    }
    
    static func getAddress(using id: String) -> NAddress? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NAddress")
        fetchRequest.predicate = NSPredicate(format: "addressId == %@", id)
        do {
            let addresses = try managedContext.fetch(fetchRequest) as? [NAddress]
            if let addresses = addresses, !addresses.isEmpty {
                return addresses.first
            }
        } catch {
            print(error)
        }
        return nil
    }

    
    func parse(json: [String : Any]) {
        self.addressId = json[KEY_ADDRESS_ID] as? String
        self.fullname = json[KEY_FULLNAME] as? String
        self.address = json[KEY_ADDRESS] as? String
        self.zipcode = json[KEY_ZIPCODE] as? String
        self.emailAddress = json[KEY_EMAIL] as? String
        if let provinceJson = json[KEY_PROVINCE] as? [String: Any] {
            if let id = provinceJson["id"] as? String {
                self.province = NProvince.getProvince(using: id)
            }
            if self.province == nil {
                self.province = NSEntityDescription.insertNewObject(forEntityName: "NProvince", into: AppDelegate.sharedManagedContext) as! NProvince
            }
            self.province!.parse(json: provinceJson)
        } else if let provinceString = json[KEY_PROVINCE] as? String {
            do {
                let data = provinceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let provinceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = provinceJson["id"] as? String {
                    self.province = NProvince.getProvince(using: id)
                }
                if self.province == nil {
                    self.province = NSEntityDescription.insertNewObject(forEntityName: "NProvince", into: AppDelegate.sharedManagedContext) as! NProvince
                }
                self.province!.parse(json: provinceJson)
            } catch {
                print(error)
            }
        }
        if let cityJson = json[KEY_CITY] as? [String: Any] {
            if let id = cityJson["id"] as? String {
                self.city = NCity.getCity(using: id)
            }
            if self.city == nil {
                self.city = NSEntityDescription.insertNewObject(forEntityName: "NCity", into: AppDelegate.sharedManagedContext) as! NCity
            }
            self.city!.parse(json: cityJson)
        } else if let cityString = json[KEY_CITY] as? String {
            do {
                let data = cityString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let cityJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = cityJson["id"] as? String {
                    self.city = NCity.getCity(using: id)
                }
                if self.city == nil {
                    self.city = NSEntityDescription.insertNewObject(forEntityName: "NCity", into: AppDelegate.sharedManagedContext) as! NCity
                }
                self.city!.parse(json: cityJson)
            } catch {
                print(error)
            }
        }
        if let districtJson = json[KEY_DISTRICT] as? [String: Any] {
            if let id = districtJson["id"] as? String {
                self.district = NDistrict.getDistrict(using: id)
            }
            if self.district == nil {
                self.district = NSEntityDescription.insertNewObject(forEntityName: "NDistrict", into: AppDelegate.sharedManagedContext) as! NDistrict
            }
            self.district!.parse(json: districtJson)
        } else if let districtString = json[KEY_DISTRICT] as? String {
            do {
                let data = districtString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let districtJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = districtJson["id"] as? String {
                    self.district = NDistrict.getDistrict(using: id)
                }
                if self.district == nil {
                    self.district = NSEntityDescription.insertNewObject(forEntityName: "NDistrict", into: AppDelegate.sharedManagedContext) as! NDistrict
                }
                self.district!.parse(json: districtJson)
            } catch {
                print(error)
            }
        }
        self.phoneNumber = json[KEY_PHONE_NUMBER] as? String
        if let defaultBilling = json[KEY_DEFAULT_BILLING] as? Int {
            self.default_billling = Int16(defaultBilling)
        } else if let defaultBilling = json[KEY_DEFAULT_BILLING] as? String {
            if defaultBilling.isNumber {
                self.default_billling = Int16(defaultBilling)!
            }
        }
        if let defaultShipping = json[KEY_DEFAULT_SHIPPING] as? Int {
            self.default_shipping = Int16(defaultShipping)
        } else if let defaultShipping = json[KEY_DEFAULT_SHIPPING] as? String {
            if defaultShipping.isNumber {
                self.default_shipping = Int16(defaultShipping)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let addressId = self.addressId {
            json[KEY_ADDRESS_ID] = addressId
        }
        if let fullname = self.fullname {
            json[KEY_FULLNAME] = fullname
        }
        if let address = self.address {
            json[KEY_ADDRESS] = address
        }
        if let zipcode = self.zipcode {
            json[KEY_ZIPCODE] = zipcode
        }
        if let province = self.province {
            json[KEY_PROVINCE] = province.serialized()
        }
        if let city = self.city {
            json[KEY_CITY] = city.serialized()
        }
        if let district = self.district {
            json[KEY_DISTRICT] = district.serialized()
        }
        if let phoneNumber = self.phoneNumber {
            json[KEY_PHONE_NUMBER] = phoneNumber
        }
        json[KEY_DEFAULT_BILLING] = Int(default_billling)
        json[KEY_DEFAULT_SHIPPING] = Int(default_shipping)
        return json
    }
    
    
}

extension NProductCategory {
    func parse(json: [String : Any]) {
        self.id = json["id"] as? String
        self.categoryName = json["name"] as? String
        self.categoryImage = json["image_url"] as? String
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json["id"] = id
        }
        if let name = self.categoryName {
            json["name"] = name
        }
        if let icon = self.categoryImage {
            json["image_url"] = icon
        }
        return json
    }
    
    static func getCategories() -> [NProductCategory]? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NProductCategory")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let categories = try managedContext.fetch(fetchRequest) as? [NProductCategory]
            if let categories = categories, !categories.isEmpty {
                return categories
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getCategory(using id: String) -> NProductCategory? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NProductCategory")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let categories = try managedContext.fetch(fetchRequest) as? [NProductCategory]
            if let categories = categories, !categories.isEmpty {
                return categories.first
            }
        } catch {
            print(error)
        }
        return nil
    }

}
