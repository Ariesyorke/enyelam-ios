//
//  NHTTPHelper+General.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpGetUpdateVersion(complete: @escaping (NHTTPResponse<Update>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_UPDATE_VERSION,
                              parameters: ["platfom": "ios", "version": NConstant.appVersion],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var update: Update? = nil
                                    if let updateJson = json["update"] as? [String: Any] {
                                        update = Update(json: updateJson)
                                    } else if let updateString = json["update"] as? String {
                                        do {
                                            let data = updateString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let updateJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                            update = Update(json: updateJson)
                                        } catch {
                                            print(error)
                                        }

                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: update, error: nil))
                                }
        })
    }
    
    static func httpGetMinMaxPrice(type: String,  diver: Int, certificate: Int?, date: Date?, categories: [String]?, diveSpotId: String?, provinceId: String?, cityId: String?, diveCenterId: String?,ecoTrip: Int?, totalDives: [Int]?, facilites: [String]?, complete: @escaping (NHTTPResponse<Price>) -> ()) {
        var param: [String: Any] = ["type": type,
                                    "diver": String(diver)]
        if let certificate = certificate {
            param["certificate"] = String(certificate)
        }
        if let date = date {
            param["date"] = String(date.timeIntervalSince1970)
        }
        if let categories = categories, !categories.isEmpty {
            param["dive_category"] = categories
        }
        if let diveSpotId = diveSpotId {
            param["dive_spot_id"] = diveSpotId
        }
        if let provinceId = provinceId {
            param["province_id"] = provinceId
        }
        if let cityId = cityId  {
            param["city_id"] = cityId
        }
        if let diveCenterId = diveCenterId {
            param["dive_center_id"] = diveCenterId
        }
        if let ecotrip = ecoTrip {
            param["eco_trip"] = ecotrip
        }
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
            
        }
        if let facilites = facilites {
            param["facilities"] = facilites
        }
        
        self.basicPostRequest(
            URLString: HOST_URL+API_PATH_MIN_MAX_PRICE,
            parameters:param,
            headers:nil,
            complete:
            {status, data, error in
                if let error = error {
                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                    return
                }
                var price: Price? = nil
                if let data = data, let json = data as? [String: Any] {
                    if let priceJson = json["price"] as? [String: Any] {
                        price = Price(json: priceJson)
                    } else if let priceString = json["price"] as? String {
                        do {
                            let data = priceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                            let priceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                            price = Price(json: priceJson)
                        } catch {
                            print(error)
                        }
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: price, error: nil))
        })
    }
    
    static func httpGetHomepageModule(complete: @escaping (NHTTPResponse<[Module]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_HOMEPAGE_MODULES,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var modules: [Module]? = nil
                if let modulesArray = json["modules"] as? Array<[String: Any]>, !modulesArray.isEmpty {
                    modules = []
                    for moduleJson in modulesArray {
                        if let _ = moduleJson["trips"] as? Array<[String: Any]> {
                            let module = TripModule(json: moduleJson)
                            modules!.append(module)
                        } else if let _ = moduleJson["trips"] as? String {
                            let module = TripModule(json: moduleJson)
                            modules!.append(module)
                        }
                    }
                } else if let modulesString = json["modules"] as? String {
                    do {
                        let data = modulesString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let modulesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        modules = []
                        for moduleJson in modulesArray {
                            if let _ = moduleJson["trips"] as? Array<[String: Any]> {
                                let module = TripModule(json: moduleJson)
                                modules!.append(module)
                            } else if let _ = moduleJson["trips"] as? String {
                                let module = TripModule(json: moduleJson)
                                modules!.append(module)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: modules, error: nil))
            }
        })
    }
}
