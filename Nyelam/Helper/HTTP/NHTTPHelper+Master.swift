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
    static func masterCategories(complete: @escaping (NHTTPResponse<[NCategory]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_CATEGORY, complete: {status, data, error in
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
                            category = NCategory()
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
                                category = NCategory()
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
    
    static func masterCountryCode(complete: @escaping (NHTTPResponse<[NCountryCode]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_CATEGORY, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var countryCodes: [NCountryCode]? = nil
                if let countryCodeArray = json["area_code"] as? Array<[String: Any]>, !countryCodeArray.isEmpty {
                    countryCodes = []
                    for countryCodeJson in countryCodeArray {
                        var countryCode: NCountryCode? = nil
                        if let id = countryCodeJson["id"] as? String {
                            countryCode = NCountryCode.getCountryCode(using: id)
                        }
                        if countryCode == nil {
                            countryCode = NCountryCode()
                        }
                        countryCode!.parse(json: countryCodeJson)
                        countryCodes!.append(countryCode!)
                    }
                } else if let categoriesString = json["categories"] as? String {
                    do {
                        let data = categoriesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let countryCodeArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        countryCodes = []
                        for countryCodeJson in countryCodeArray {
                            var countryCode: NCountryCode? = nil
                            if let id = countryCodeJson["id"] as? String {
                                countryCode = NCountryCode.getCountryCode(using: id)
                            }
                            if countryCode == nil {
                                countryCode = NCountryCode()
                            }
                            countryCode!.parse(json: countryCodeJson)
                            countryCodes!.append(countryCode!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: countryCodes, error: nil))
            }
        })
    }
}
