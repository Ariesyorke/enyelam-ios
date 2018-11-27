//
//  NHTTPHelper+DoDive.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

extension NHTTPHelper {
    static func httpGetDistrict(cityId: String,
                                complete: @escaping(NHTTPResponse<[NDistrict]>)->()) {
        self.basicRajaOngkirRequest(
            URLString: RAJA_ONGKIR_URL + API_PATH_GET_RAJA_ONGKIR_SUB_DISTRICT,
            method: .get,
            parameters: ["city": cityId],
            headers: nil,
            encoding: URLEncoding.default,
            complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var districts: [NDistrict]? = nil
                if let districtArray = json["results"] as? Array<[String: Any]>, !districtArray.isEmpty {
                    districts = []
                    for districtJson in districtArray {
                        var district: NDistrict? = nil
                        if let id = districtJson["subdistrict_id"] as? String {
                            district = NDistrict.getDistrict(using: id)
                        }
                        if district == nil {
                            district = NDistrict.init(entity: NSEntityDescription.entity(forEntityName: "NDistrict", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        district!.parse(json: districtJson)
                        districts!.append(district!)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: districts, error: nil))
            }
        })
    }
    static func httpGetCity(
        provinceId: String,
        complete: @escaping (NHTTPResponse<[NCity]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_GET_LOCATION, parameters: ["province_id": provinceId], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var cities: [NCity]? = nil
                if let cityArray = json["areas"] as? Array<[String: Any]>,
                    !cityArray.isEmpty {
                    cities = []
                    for cityJson in cityArray {
                        var city: NCity? = nil
                        if let id = cityJson["id"] as? String {
                            city = NCity.getCity(using: id)
                        }
                        if city == nil {
                            city = NCity.init(entity: NSEntityDescription.entity(forEntityName: "NCity", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        city!.parse(json: cityJson)
                        cities!.append(city!)
                    }
                } else if let citiesString = json["areas"] as? String {
                    do {
                        cities = []
                        let data = citiesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let cityArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for cityJson in cityArray {
                            var city: NCity? = nil
                            if let id = cityJson["id"] as? String {
                                city = NCity.getCity(using: id)
                            }
                            if city == nil {
                                city = NCity.init(entity: NSEntityDescription.entity(forEntityName: "NCity", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            city!.parse(json: cityJson)
                            cities!.append(city!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: cities, error: nil))
            }
        })
    }
    
    static func httpGetProvince(complete: @escaping (NHTTPResponse<[NProvince]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_GET_LOCATION,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var provinces: [NProvince]? = nil
                                    if let provincesArray = json["areas"] as? Array<[String: Any]>,
                                        !provincesArray.isEmpty {
                                        provinces = []
                                        for provinceJson in provincesArray {
                                            var province: NProvince? = nil
                                            if let id = provinceJson["id"] as? String {
                                                province = NProvince.getProvince(using: id)
                                            }
                                            if province == nil {
                                                province = NProvince.init(entity: NSEntityDescription.entity(forEntityName: "NProvince", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            province!.parse(json: provinceJson)
                                            provinces!.append(province!)
                                        }
                                    } else if let provincesString = json["areas"] as? String {
                                        do {
                                            provinces = []
                                            let data = provincesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let provincesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            for provinceJson in provincesArray {
                                                var province: NProvince? = nil
                                                if let id = provinceJson["id"] as? String {
                                                    province = NProvince.getProvince(using: id)
                                                }
                                                if province == nil {
                                                    province = NProvince.init(entity: NSEntityDescription.entity(forEntityName: "NProvince", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                province!.parse(json: provinceJson)
                                                provinces!.append(province!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: provinces, error: nil))
                                }
        })
    }
    
    static func httpGetMasterOrganization(complete: @escaping (NHTTPResponse<[NMasterOrganization]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_ORGANIZATION) { status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var organizations: [NMasterOrganization]? = nil
                if let organizationArray = json["organizations"] as? Array<[String: Any]>, !organizationArray.isEmpty {
                    organizations = []
                    for organizationJson in organizationArray {
                        var organization: NMasterOrganization? = nil
                        if let id = organizationJson["id"] as? String {
                            organization = NMasterOrganization.getOrganization(using: id)
                        }
                        if organization == nil {
                            organization = NMasterOrganization.init(entity: NSEntityDescription.entity(forEntityName: "NMasterOrganization", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        organization!.parse(json: organizationJson)
                        organizations!.append(organization!)
                    }
                } else if let organizationString = json["organizations"] as? String {
                    do {
                        organizations = []
                        let data = organizationString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let organizationArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for organizationJson in organizationArray {
                            var organization: NMasterOrganization? = nil
                            if let id = organizationJson["id"] as? String {
                                organization = NMasterOrganization.getOrganization(using: id)
                            }
                            if organization == nil {
                                organization = NMasterOrganization.init(entity: NSEntityDescription.entity(forEntityName: "NMasterOrganization", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            organization!.parse(json: organizationJson)
                            organizations!.append(organization!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: organizations, error: nil))
            }
        }
    }
    static func httpGetLicenseType(organizationId: String, complete: @escaping (NHTTPResponse<[NLicenseType]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_LICENSE,
                              parameters: ["organization_id":organizationId],
                              headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var licenseTypes: [NLicenseType]? = nil
                                    if let licenseTypesArray = json["lisence_types"] as? Array<[String: Any]>, !licenseTypesArray.isEmpty {
                                        licenseTypes = []
                                        for licenseTypeJson in licenseTypesArray {
                                            var licenseType: NLicenseType? = nil
                                            if let id = licenseTypeJson["id"] as? String {
                                                licenseType = NLicenseType.getLicenseType(using: id)
                                            }
                                            if licenseType == nil {
                                                licenseType = NLicenseType.init(entity: NSEntityDescription.entity(forEntityName: "NLicenseType", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            licenseType!.parse(json: licenseTypeJson)
                                            NSManagedObjectContext.saveData()
                                            licenseTypes!.append(licenseType!)
                                        }
                                    } else if let licenseTypesString = json["lisence_types"] as? String {
                                        do {
                                            let data = licenseTypesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let licenseTypesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            licenseTypes = []
                                            for licenseTypeJson in licenseTypesArray {
                                                var licenseType: NLicenseType? = nil
                                                if let id = licenseTypeJson["id"] as? String {
                                                    licenseType = NLicenseType.getLicenseType(using: id)
                                                }
                                                if licenseType == nil {
                                                    licenseType = NLicenseType.init(entity: NSEntityDescription.entity(forEntityName: "NLicenseType", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                licenseType!.parse(json: licenseTypeJson)
                                                NSManagedObjectContext.saveData()
                                                licenseTypes!.append(licenseType!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: licenseTypes, error: nil))
                                }
        })
    }
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
    
    static func httpGetMasterDoShopCategory(complete: @escaping (NHTTPResponse<[NProductCategory]>) -> ()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_SHOP_CATEGORY, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var categories: [NProductCategory]? = nil
                if let categoriesArray = json["categories"] as? Array<[String: Any]>, !categoriesArray.isEmpty {
                    categories = []
                    for categoryJson in categoriesArray {
                        var category: NProductCategory? = nil
                        if let id = categoryJson["id"] as? String {
                            category = NProductCategory.getCategory(using: id)
                        }
                        if category == nil {
                            category = NProductCategory.init(entity: NSEntityDescription.entity(forEntityName: "NProductCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
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
                            var category: NProductCategory? = nil
                            if let id = categoryJson["id"] as? String {
                                category = NProductCategory.getCategory(using: id)
                            }
                            if category == nil {
                                category = NProductCategory.init(entity: NSEntityDescription.entity(forEntityName: "NProductCategory", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
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
}
