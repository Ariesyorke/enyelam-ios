//
//  NUser+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NUser)
public class NUser: NSManagedObject {
    private let KEY_USER_ID = "user_id"
    private let KEY_FULLNAME = "fullname"
    private let KEY_FIRSTNAME = "firstname"
    private let KEY_LASTNAME = "lastname"
    private let KEY_PHONE = "phone_number"
    private let KEY_EMAIL = "email"
    private let KEY_PICTURE = "picture"
    private let KEY_GENDER = "gender"
    private let KEY_IS_VERIFIED = "is_verified"
    private let KEY_REFERRAL_CODE = "referral_code"
    private let KEY_ADDRESS = "address"
    private let KEY_FILE_PATH = "file_path"
    private let KEY_BIRTHPLACE = "birthplace"
    private let KEY_BIRTHDATE = "birthdate"
    private let KEY_CERTIFICATE_NUMBER = "certificate_number"
    private let KEY_CERTIFICATE_DATE = "certificate_date"
    private let KEY_USERNAME = "username"
    private let KEY_COVER = "cover"
    private let KEY_COUNTRY_CODE = "country_code"
    private let KEY_SOCIAL_MEDIA = "social_media"
    private let KEY_COUNTRY = "country"
    private let KEY_NATIONALITY = "nationality"
    private let KEY_LANGUAGE = "language"
    
    func parse(json: [String : Any]) {
        self.id = json[KEY_USER_ID] as? String
        self.fullname = json[KEY_FULLNAME] as? String
        self.firstName = json[KEY_FIRSTNAME] as? String
        self.lastName = json[KEY_LASTNAME] as? String
        self.phone = json[KEY_PHONE] as? String
        self.email = json[KEY_EMAIL] as? String
        self.gender = json[KEY_GENDER] as? String
        self.picture = json[KEY_PICTURE] as? String
        if let isVerified = json[KEY_IS_VERIFIED] as? Bool {
            self.isVerified = isVerified
        } else if let isVerified = json[KEY_IS_VERIFIED] as? String {
            self.isVerified = isVerified.toBool
        }
        self.referralCode = json[KEY_REFERRAL_CODE] as? String
        self.address = json[KEY_ADDRESS] as? String
        self.birthPlace = json[KEY_BIRTHPLACE] as? String
        if let birthDateTimeStamp = json[KEY_BIRTHDATE] as? Double {
            self.birthDate = NSDate(timeIntervalSince1970: birthDateTimeStamp)
        } else if let birthDateTimeStamp = json[KEY_BIRTHDATE] as? String {
            if birthDateTimeStamp.isNumber {
                let timestamp = Double(birthDateTimeStamp)!
                self.birthDate = NSDate(timeIntervalSince1970: timestamp)
            }
        }
        self.certificateNumber = json[KEY_CERTIFICATE_NUMBER] as? String
        if let certificateTimeStamp = json[KEY_CERTIFICATE_DATE] as? Double {
            self.certificateDate = NSDate(timeIntervalSince1970: certificateTimeStamp)
        } else if let certificateTimestamp = json[KEY_CERTIFICATE_DATE] as? String {
            if certificateTimestamp.isNumber {
                let timestamp = Double(certificateTimestamp)!
                self.birthDate = NSDate(timeIntervalSince1970: timestamp)
            }
        }
        self.username = json[KEY_USERNAME] as? String
        self.cover = json[KEY_COVER] as? String
        if let countryCodeJson = json[KEY_COUNTRY_CODE] as? [String: Any] {
            if let id = countryCodeJson["id"] as? String {
                self.countryCode = NCountryCode.getCountryCode(using: id)
            }
            if self.countryCode == nil {
                self.countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

            }
            self.countryCode!.parse(json: json)
        } else if let countryCodeString = json[KEY_COUNTRY_CODE] as? String {
            do {
                let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryCodeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryCodeJson["id"] as? String {
                    self.countryCode = NCountryCode.getCountryCode(using: id)
                }
                if self.countryCode == nil {
                    self.countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.countryCode!.parse(json: json)
            } catch {
                print(error)
            }
        }
        if let countryJson = json[KEY_COUNTRY] as? [String: Any] {
            if let id = countryJson["id"] as? String {
                self.country = NCountry.getCountry(using: id)
            }
            if self.country == nil {
                self.country = NCountry.init(entity: NSEntityDescription.entity(forEntityName: "NCountry", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
            }
            self.country!.parse(json: json)
        } else if let countryString = json[KEY_COUNTRY] as? String {
            do {
                let data = countryString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryJson["id"] as? String {
                    self.country = NCountry.getCountry(using: id)
                }
                if self.country == nil {
                    self.country = NCountry.init(entity: NSEntityDescription.entity(forEntityName: "NCountry", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.country!.parse(json: json)
            } catch {
                print(error)
            }
        }
        if let socialMediaArray = json[KEY_SOCIAL_MEDIA] as? Array<[String: Any]>, !socialMediaArray.isEmpty {
            for socialMediaJson in socialMediaArray {
                var socialMedia: NSocialMedia? = nil
                if let id = socialMediaJson["id"] as? String, let type = socialMediaJson["type"] as? String {
                    socialMedia = NSocialMedia.getSocialMedia(using: id, and: type)
                }
                if socialMedia == nil {
                    socialMedia = NSocialMedia.init(entity: NSEntityDescription.entity(forEntityName: "NSocialMedia", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                socialMedia!.parse(json: json)
                self.addToSocialMedias(socialMedia!)
            }
        } else if let socialMediaSring = json[KEY_SOCIAL_MEDIA] as? String {
            do {
                let data = socialMediaSring.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let socialMediaArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for socialMediaJson in socialMediaArray {
                    var socialMedia: NSocialMedia? = nil
                    if let id = socialMediaJson["id"] as? String, let type = socialMediaJson["type"] as? String {
                        socialMedia = NSocialMedia.getSocialMedia(using: id, and: type)
                    }
                    if socialMedia == nil {
                        socialMedia = NSocialMedia.init(entity: NSEntityDescription.entity(forEntityName: "NSocialMedia", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                    }
                    socialMedia!.parse(json: json)
                    self.addToSocialMedias(socialMedia!)
                }
            } catch {
                print(error)
            }
        }
        if let languageJson = json[KEY_LANGUAGE] as? [String: Any] {
            if let id = languageJson["id"] as? String {
                self.language = NLanguage.getLanguage(using: id)
            }
            if self.language == nil {
                self.language = NLanguage.init(entity: NSEntityDescription.entity(forEntityName: "NLanguage", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

            }
            self.language!.parse(json: json)
        } else if let languageString = json[KEY_LANGUAGE] as? String {
            do {
                let data = languageString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let languageJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = languageJson["id"] as? String {
                    self.language = NLanguage.getLanguage(using: id)
                }
                if self.language == nil {
                    self.language = NLanguage.init(entity: NSEntityDescription.entity(forEntityName: "NLanguage", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.language!.parse(json: json)
            } catch {
                print(error)
            }
        }
        if let nationalityJson = json[KEY_NATIONALITY] as? [String: Any] {
            if let id = nationalityJson["id"] as? String {
                self.nationality = NNationality.getNationality(using: id)
            }
            if self.nationality == nil {
                self.nationality = NNationality.init(entity: NSEntityDescription.entity(forEntityName: "NNationality", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

            }
            self.nationality!.parse(json: json)
        } else if let nationalityString = json[KEY_NATIONALITY] as? String {
            do {
                let data = nationalityString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let nationalityJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = nationalityJson["id"] as? String {
                    self.nationality = NNationality.getNationality(using: id)
                }
                if self.nationality == nil {
                    self.nationality = NNationality.init(entity: NSEntityDescription.entity(forEntityName: "NNationality", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.nationality!.parse(json: json)
            } catch {
                print(error)
            }
        }
        if let countryCodeJson = json[KEY_COUNTRY_CODE] as? [String: Any] {
            if let id = countryCodeJson["id"] as? String {
                self.countryCode = NCountryCode.getCountryCode(using: id)
            }
            if self.countryCode == nil {
                self.countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
            }
            self.countryCode!.parse(json: countryCodeJson)
        } else if let countryCodeString = json[KEY_COUNTRY_CODE] as? String {
            do {
                let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let countryCodeJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = countryCodeJson["id"] as? String {
                    self.countryCode = NCountryCode.getCountryCode(using: id)
                }
                if self.countryCode == nil {
                    self.countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.countryCode!.parse(json: countryCodeJson)
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_USER_ID] = id
        }
        if let fullname = self.fullname {
            json[KEY_FULLNAME] = fullname
        }
        if let firstName = self.firstName {
            json[KEY_FIRSTNAME] = firstName
        }
        if let lastName = self.lastName {
            json[KEY_LASTNAME] = lastName
        }
        if let phoneNumber = self.phone {
            json[KEY_PHONE] = phoneNumber
        }
        if let email = self.email {
            json[KEY_EMAIL] = email
        }
        if let gender = self.gender {
            json[KEY_GENDER] = gender
        }
        json[KEY_IS_VERIFIED] = self.isVerified
        if let referralCode = self.referralCode {
            json[KEY_REFERRAL_CODE] = referralCode
        }
        if let address = self.address {
            json[KEY_ADDRESS] = address
        }
        if let birthPlace = self.birthPlace {
            json[KEY_BIRTHPLACE] = birthPlace
        }
        if let birthDate = self.birthDate {
            json[KEY_BIRTHDATE] = birthDate.timeIntervalSince1970
        }
        if let certificateNumber = self.certificateNumber {
            json[KEY_CERTIFICATE_NUMBER] = certificateNumber
        }
        if let certificateDate = self.certificateDate {
            json[KEY_CERTIFICATE_DATE] = certificateDate.timeIntervalSince1970
        }
        if let userName = self.username {
            json[KEY_USERNAME] = userName
        }
        if let cover = self.cover {
            json[KEY_COVER] = cover
        }
        if let nsset = self.socialMedias, let socialMedias = nsset.allObjects as? [NSocialMedia] {
            var array: Array<[String: Any]> = []
            for socialMedia in socialMedias {
                array.append(socialMedia.serialized())
            }
            json[KEY_SOCIAL_MEDIA] = array
        }
        if let country = self.country {
            json[KEY_COUNTRY] = country.serialized()
        }
        if let nationality = self.nationality {
            json[KEY_NATIONALITY] = nationality.serialized()
        }
        if let language = self.language {
            json[KEY_LANGUAGE] = language.serialized()
        }
        if let picture = self.picture {
            json[KEY_PICTURE] = picture
        }
        if let countryCode = self.countryCode {
            json[KEY_COUNTRY_CODE] = countryCode.serialized()
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
