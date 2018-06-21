//
//  NHTTPHelper+DoCourse.swift
//  Nyelam
//
//  Created by Bobi on 5/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import CoreData

extension NHTTPHelper {
    static func httpDoCourseSearchBy(diveCenterId: String, page: String, date: TimeInterval, selectedDiver: Int, sortBy: Int, organizationId: String, licenseTypeId: String, openWater: Int?, priceMin: Int?, priceMax: Int?, facilities: [String]?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = ["dive_center_id": diveCenterId,
                                    "page": page,
                                    "selected_diver": String(selectedDiver),
                                    "organization_id": organizationId,
                                    "license_type_id": licenseTypeId,
                                    "date": String(date),
                                    "sort_by":String(sortBy)]
        
        if let openWater = openWater {
            param["open_water"] = String(openWater)
        }
        if let priceMin = priceMin {
            param["price_min"] = priceMin
        }
        if let priceMax = priceMax {
            param["price_max"] = priceMax
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_COURSE_SEARCH_BY_DIVECENTER, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var diveservices: [NDiveService]? = nil
                if let diveServiceArray = json["course"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                    diveservices = []
                    for diveServiceJson in diveServiceArray {
                        var diveService: NDiveService? = nil
                        if let id = diveServiceJson["id"] as? String {
                            diveService = NDiveService.getDiveService(using: id)
                        }
                        if diveService == nil {
                            diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        diveService!.shouldParseDivespot = false
                        diveService!.parse(json: diveServiceJson)
                        diveservices!.append(diveService!)
                    }
                } else if let diveServiceString = json["course"] as? String {
                    do {
                        let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        diveservices = []
                        for diveServiceJson in diveServiceArray {
                            var diveService: NDiveService? = nil
                            if let id = diveServiceJson["id"] as? String {
                                diveService = NDiveService.getDiveService(using: id)
                            }
                            if diveService == nil {
                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            diveService!.shouldParseDivespot = false
                            diveService!.parse(json: diveServiceJson)
                            diveservices!.append(diveService!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
            }
        })
    }
    
    static func httpDoCourseSearchBy(provinceId: String, page: String, date: TimeInterval, selectedDiver: Int, sortBy: Int, organizationId: String, licenseTypeId: String, openWater: Int?, priceMin: Int?, priceMax: Int?, facilities: [String]?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = ["province_id": provinceId,
                                    "page": page,
                                    "selected_diver": String(selectedDiver),
                                    "organization_id": organizationId,
                                    "license_type_id": licenseTypeId,
                                    "date": String(date),
                                    "sort_by":String(sortBy)]
        
        if let openWater = openWater {
            param["open_water"] = String(openWater)
        }
        if let priceMin = priceMin {
            param["price_min"] = priceMin
        }
        if let priceMax = priceMax {
            param["price_max"] = priceMax
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_COURSE_SEARCH_BY_PROVINCE, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var diveservices: [NDiveService]? = nil
                if let diveServiceArray = json["course"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                    diveservices = []
                    for diveServiceJson in diveServiceArray {
                        var diveService: NDiveService? = nil
                        if let id = diveServiceJson["id"] as? String {
                            diveService = NDiveService.getDiveService(using: id)
                        }
                        if diveService == nil {
                            diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        diveService!.parse(json: diveServiceJson)
                        diveservices!.append(diveService!)
                    }
                } else if let diveServiceString = json["course"] as? String {
                    do {
                        let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        diveservices = []
                        for diveServiceJson in diveServiceArray {
                            var diveService: NDiveService? = nil
                            if let id = diveServiceJson["id"] as? String {
                                diveService = NDiveService.getDiveService(using: id)
                            }
                            if diveService == nil {
                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            diveService!.parse(json: diveServiceJson)
                            diveservices!.append(diveService!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
            }
        })
    }
    
    static func httpDoCourseSearchBy(cityId: String, page: String, date: TimeInterval, selectedDiver: Int, sortBy: Int, organizationId: String, licenseTypeId: String, openWater: Int?, priceMin: Int?, priceMax: Int?, facilities: [String]?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = ["city_id": cityId,
                                    "page": page,
                                    "selected_diver": String(selectedDiver),
                                    "organization_id": organizationId,
                                    "license_type_id": licenseTypeId,
                                    "date": String(date),
                                    "sort_by":String(sortBy)]
        
        if let openWater = openWater {
            param["open_water"] = String(openWater)
        }
        if let priceMin = priceMin {
            param["price_min"] = priceMin
        }
        if let priceMax = priceMax {
            param["price_max"] = priceMax
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_COURSE_SEARCH_BY_CITY, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var diveservices: [NDiveService]? = nil
                if let diveServiceArray = json["course"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                    diveservices = []
                    for diveServiceJson in diveServiceArray {
                        var diveService: NDiveService? = nil
                        if let id = diveServiceJson["id"] as? String {
                            diveService = NDiveService.getDiveService(using: id)
                        }
                        if diveService == nil {
                            diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        diveService!.parse(json: diveServiceJson)
                        diveservices!.append(diveService!)
                    }
                } else if let diveServiceString = json["course"] as? String {
                    do {
                        let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        diveservices = []
                        for diveServiceJson in diveServiceArray {
                            var diveService: NDiveService? = nil
                            if let id = diveServiceJson["id"] as? String {
                                diveService = NDiveService.getDiveService(using: id)
                            }
                            if diveService == nil {
                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            diveService!.parse(json: diveServiceJson)
                            diveservices!.append(diveService!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
            }
        })
    }
    
    static func httpDoCourseSuggestion(complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DO_COURSE_SUGGESTION, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var diveservices: [NDiveService]? = nil
                if let diveServiceArray = json["course"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                    diveservices = []
                    for diveServiceJson in diveServiceArray {
                        var diveService: NDiveService? = nil
                        if let id = diveServiceJson["id"] as? String {
                            diveService = NDiveService.getDiveService(using: id)
                        }
                        if diveService == nil {
                            diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        diveService!.parse(json: diveServiceJson)
                        diveservices!.append(diveService!)
                    }
                } else if let diveServiceString = json["course"] as? String {
                    do {
                        let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        diveservices = []
                        for diveServiceJson in diveServiceArray {
                            var diveService: NDiveService? = nil
                            if let id = diveServiceJson["id"] as? String {
                                diveService = NDiveService.getDiveService(using: id)
                            }
                            if diveService == nil {
                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            diveService!.parse(json: diveServiceJson)
                            diveservices!.append(diveService!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
            }
        })
    }
}
