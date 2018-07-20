//
//  NHTTPHelper+Detail.swift
//  Nyelam
//
//  Created by Bobi on 4/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpDetail(serviceId: String, diver: Int,
                                  certificate: Int, date: Date, complete: @escaping (NHTTPResponse<NDiveService>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DETAIL_SERVICE,
                              parameters: [
                                "service_id": serviceId,
                                "certificate": String(certificate),
                                "date": String(date.timeIntervalSince1970),
                                "diver":  diver], headers: nil, complete: {status, data, error in
                                    if let error = error {
                                        complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                        return
                                    }
                                    if let data = data, let json = data as? [String: Any] {
                                        var service: NDiveService? = nil
                                        if let serviceJson = json["service"] as? [String: Any] {
                                            if let id = serviceJson["id"] as? String {
                                                service = NDiveService.getDiveService(using: id)
                                            }
                                            if service == nil {
                                                service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            service!.shouldParseDivespot = true
                                            service!.parse(json: serviceJson)
                                        } else if let serviceString = json["service"] as? String {
                                            do {
                                                let data = serviceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                                let serviceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                                if let id = serviceJson["id"] as? String {
                                                    service = NDiveService.getDiveService(using: id)
                                                }
                                                if service == nil {
                                                    service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                service!.shouldParseDivespot = true
                                                service!.parse(json: serviceJson)
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        NSManagedObjectContext.saveData {
                                            complete(NHTTPResponse(resultStatus: true, data: service, error: nil))
                                        }
                                    }
        })
    }
    
    static func httpDetail(diveCenterId: String,  complete: @escaping (NHTTPResponse<NDiveCenter>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DIVE_CENTER_DETAIL,
                              parameters: ["dive_center_id": diveCenterId], headers: nil, complete: {status, data, error in
                                            if let error = error {
                                                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                                return
                                            }
                                            if let data = data, let json = data as? [String: Any] {
                                                var diveCenter: NDiveCenter? = nil
                                                if let diveCenterJson = json["dive_center"] as? [String: Any] {
                                                    if let id = diveCenterJson["id"] as? String {
                                                        diveCenter = NDiveCenter.getDiveCenter(using: id)
                                                    }
                                                    if diveCenter == nil {
                                                        diveCenter = NDiveCenter.init(entity: NSEntityDescription.entity(forEntityName: "NDiveCenter", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                    }
                                                    diveCenter!.parse(json: diveCenterJson)
                                                } else if let diveCenterString = json["service"] as? String {
                                                    do {
                                                        let data = diveCenterString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                                        let diveCenterJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                                        if let id = diveCenterJson["id"] as? String {
                                                            diveCenter = NDiveCenter.getDiveCenter(using: id)
                                                        }
                                                        if diveCenter == nil {
                                                            diveCenter = NDiveCenter.init(entity: NSEntityDescription.entity(forEntityName: "NDiveCenter", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                        }
                                                        diveCenter!.parse(json: diveCenterJson)
                                                    } catch {
                                                        print(error)
                                                    }
                                                }
                                                NSManagedObjectContext.saveData {
                                                    complete(NHTTPResponse(resultStatus: true, data: diveCenter, error: nil))
                                                }
                                            }
                                
        })
    }
    
    static func httpDetail(bookingId: String, complete: @escaping (NHTTPResponse<OrderReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_BOOKING_DETAIL, parameters: ["booking_detail_id":bookingId], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            print("data \(data)")
            if let data = data, let json = data as? [String: Any] {
                let order = OrderReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: order, error: nil))
            }
        })
    }
    
    static func httpDetail(doCourseId: String,
                           diver: Int, date: Date,
                           complete: @escaping  (NHTTPResponse<NDiveService>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DO_COURSE_DETAIL,
                              parameters: [
                                "do_course_id": doCourseId,
                                "date": String(date.timeIntervalSince1970),
                                "diver":  diver], headers: nil, complete: {status, data, error in
                                    if let error = error {
                                        complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                        return
                                    }
                                    if let data = data, let json = data as? [String: Any] {
                                        var service: NDiveService? = nil
                                        if let serviceJson = json["service"] as? [String: Any] {
                                            if let id = serviceJson["id"] as? String {
                                                service = NDiveService.getDiveService(using: id)
                                            }
                                            if service == nil {
                                                service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            service!.shouldParseDivespot = true
                                            service!.parse(json: serviceJson)
                                        } else if let serviceString = json["service"] as? String {
                                            do {
                                                let data = serviceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                                let serviceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                                if let id = serviceJson["id"] as? String {
                                                    service = NDiveService.getDiveService(using: id)
                                                }
                                                if service == nil {
                                                    service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                service!.shouldParseDivespot = true
                                                service!.parse(json: serviceJson)
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        NSManagedObjectContext.saveData {
                                            complete(NHTTPResponse(resultStatus: true, data: service, error: nil))
                                        }
                                    }
        })
    }
    static func httpDetail(doTripId: String, diver: Int,
                           certificate: Int, date: Date, complete: @escaping (NHTTPResponse<NDiveService>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DO_TRIP_DETAIL,
                              parameters: [
                                "service_id": doTripId,
                                "certificate": String(certificate),
                                "date": String(date.timeIntervalSince1970),
                                "diver":  diver], headers: nil, complete: {status, data, error in
                                    if let error = error {
                                        complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                        return
                                    }
                                    if let data = data, let json = data as? [String: Any] {
                                        var service: NDiveService? = nil
                                        if let serviceJson = json["service"] as? [String: Any] {
                                            if let id = serviceJson["id"] as? String {
                                                service = NDiveService.getDiveService(using: id)
                                            }
                                            if service == nil {
                                                service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            service!.shouldParseDivespot = true
                                            service!.parse(json: serviceJson)
                                        } else if let serviceString = json["service"] as? String {
                                            do {
                                                let data = serviceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                                let serviceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                                if let id = serviceJson["id"] as? String {
                                                    service = NDiveService.getDiveService(using: id)
                                                }
                                                if service == nil {
                                                    service = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                service!.shouldParseDivespot = true
                                                service!.parse(json: serviceJson)
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        NSManagedObjectContext.saveData {
                                            complete(NHTTPResponse(resultStatus: true, data: service, error: nil))
                                        }
                                    }
        })
    }
}
