//
//  NHTTPHelper+DoDive.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpGetMasterCategories(page: String, complete: @escaping (NHTTPResponse<[NCategory]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_CATEGORY,
                              parameters: ["page": page],
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var categories: [NCategory]? = nil
                if let categoriesArray = json["categories"] as? Array<[String: Any]>, !categoriesArray.isEmpty {
                    categories = []
                    for categoryJson in categoriesArray {
                        var category: NCategory? = nil
                        if let id = categoryJson["id"] as? String {
                            category = NCategory.getCategory(using: id)
                        }
                        if category == nil {
                            category = NCategory.init(entity: NSEntityDescription.entity(forEntityName: "NCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        category!.parse(json: categoryJson)
                        categories!.append(category!)
                    }
                } else if let categoriesString = json["categories"] as? String {
                    do {
                        let data = categoriesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let categoriesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        categories = []
                        for categoryJson in categoriesArray {
                            var category: NCategory? = nil
                            if let id = categoryJson["id"] as? String {
                                category = NCategory.getCategory(using: id)
                            }
                            if category == nil {
                                category = NCategory.init(entity: NSEntityDescription.entity(forEntityName: "NCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            category!.parse(json: categoryJson)
                            categories!.append(category!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: categories, error: nil))
            }
        })
    }
    
    static func httpGetMasterCountryCode(page: String, complete: @escaping (NHTTPResponse<[NCountryCode]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_COUNTRY,
                              parameters: ["page":page],
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var countryCodes: [NCountryCode]? = nil
                if let countryCodeArray = json["area_code"] as? Array<[String: Any]>, !countryCodeArray.isEmpty {
                    countryCodes = []
                    for countryCodeJson in countryCodeArray {
                        if countryCodeJson["id"] != nil {
                            var countryCode: NCountryCode? = nil
                            if let id = countryCodeJson["id"] as? String {
                                countryCode = NCountryCode.getCountryCode(using: id)
                            }
                            if countryCode == nil {
                                countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            countryCode!.parse(json: countryCodeJson)
                            countryCodes!.append(countryCode!)
                        }
                    }
                } else if let countryCodeString = json["area_code"] as? String {
                    do {
                        let data = countryCodeString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let countryCodeArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        countryCodes = []
                        for countryCodeJson in countryCodeArray {
                            if countryCodeJson["id"] != nil {
                                var countryCode: NCountryCode? = nil
                                if let id = countryCodeJson["id"] as? String {
                                    countryCode = NCountryCode.getCountryCode(using: id)
                                }
                                if countryCode == nil {
                                    countryCode = NCountryCode.init(entity: NSEntityDescription.entity(forEntityName: "NCountryCode", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                }
                                countryCode!.parse(json: countryCodeJson)
                                countryCodes!.append(countryCode!)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: countryCodes, error: nil))
            }
        })
    }
    
    static func httpGetMasterLanguage(complete: @escaping (NHTTPResponse<[NLanguage]>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_MASTER_LANGUAGE,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var languages: [NLanguage]? = nil
                                    if let languageArray = json["language"] as? Array<[String: Any]>, !languageArray.isEmpty {
                                        languages = []
                                        for languageJson in languageArray {
                                            var language: NLanguage? = nil
                                            if let id = languageJson["id"] as? String {
                                                language = NLanguage.getLanguage(using: id)
                                            }
                                            if language == nil {
                                                language = NLanguage.init(entity: NSEntityDescription.entity(forEntityName: "NLanguage", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            language!.parse(json: languageJson)
                                            languages!.append(language!)
                                        }
                                    } else if let languageString = json["language"] as? String {
                                        do {
                                            let data = languageString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let languageArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            languages = []
                                            for languageJson in languageArray {
                                                var language: NLanguage? = nil
                                                if let id = languageJson["id"] as? String {
                                                    language = NLanguage.getLanguage(using: id)
                                                }
                                                if language == nil {
                                                    language = NLanguage.init(entity: NSEntityDescription.entity(forEntityName: "NLanguage", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                language!.parse(json: languageJson)
                                                languages!.append(language!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: languages, error: nil))
                                }
        })
    }
    
    static func httpGetMasterNationality(countryId: String, complete: @escaping (NHTTPResponse<[NNationality]>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_MASTER_NATIONALITY,
                              parameters: ["country_id": countryId],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var nationalities: [NNationality]? = nil
                                    if let nationalityArray = json["nationality"] as? Array<[String: Any]>, !nationalityArray.isEmpty {
                                        nationalities = []
                                        for nationalityJson in nationalityArray {
                                            var nationality: NNationality? = nil
                                            if let id = nationalityJson["id"] as? String {
                                                nationality = NNationality.getNationality(using: id)
                                            }
                                            if nationality == nil {
                                                nationality = NNationality.init(entity: NSEntityDescription.entity(forEntityName: "NNationality", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            nationality!.parse(json: nationalityJson)
                                            nationalities!.append(nationality!)
                                        }
                                    } else if let nationalityString = json["nationality"] as? String {
                                        do {
                                            let data = nationalityString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let nationalityArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            nationalities = []
                                            for nationalityJson in nationalityArray {
                                                var nationality: NNationality? = nil
                                                if let id = nationalityJson["id"] as? String {
                                                    nationality = NNationality.getNationality(using: id)
                                                }
                                                if nationality == nil {
                                                    nationality = NNationality.init(entity: NSEntityDescription.entity(forEntityName: "NNationality", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                nationality!.parse(json: nationalityJson)
                                                nationalities!.append(nationality!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: nationalities, error: nil))
                                }
        })
    }
}
