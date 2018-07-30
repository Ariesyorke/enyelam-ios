//
//  NHTTPHelper+DiveGuide.swift
//  Nyelam
//
//  Created by Bobi on 7/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreData

extension NHTTPHelper {
    static func httpGetDiveGuideDetail(diveGuideId: String, complete: @escaping (NHTTPResponse<NUser>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DIVE_GUIDE_DETAIL, parameters: ["dive_guide_id": diveGuideId], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var user: NUser? = nil
                if let diveGuideJson = json["dive_guide"] as? [String: Any] {
                    if let id = diveGuideJson["user_id"] as? String {
                        user = NUser.getUser(using: id)
                    }
                    if user == nil {
                        user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        user!.parse(json: diveGuideJson)
                    }
                    user!.parse(json: diveGuideJson)
                } else if let diveGuideString = json["dive_guide"] as? String {
                    do {
                        let data = diveGuideString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let diveGuideJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        if let id = diveGuideJson["user_id"] as? String {
                            user = NUser.getUser(using: id)
                        }
                        if user == nil {
                            user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            user!.parse(json: diveGuideJson)
                        }
                        user!.parse(json: diveGuideJson)
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: user, error: nil))
            }
        })
    }
    static func httpGetDiveGuideList(diveCenterId: String,  complete: @escaping (NHTTPResponse<[NUser]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_DIVE_GUIDE_LIST,
                              parameters: ["dive_center_id": diveCenterId],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var users: [NUser]? = nil
                                    if let diveGuideArray = json["dive_guides"] as? Array<[String: Any]>, !diveGuideArray.isEmpty {
                                        users = []
                                        for diveGuideJson in diveGuideArray {
                                            var user: NUser? = nil
                                            if let id = diveGuideJson["user_id"] as? String {
                                                user = NUser.getUser(using: id)
                                            }
                                            if user == nil {
                                                user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                user!.parse(json: diveGuideJson)
                                            }
                                            user!.parse(json: diveGuideJson)
                                            users!.append(user!)
                                        }
                                    } else if let diveGuideString = json["dive_guides"] as? String {
                                        do {
                                            let data = diveGuideString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveGuideArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            users = []
                                            for diveGuideJson in diveGuideArray {
                                                var user: NUser? = nil
                                                if let id = diveGuideJson["user_id"] as? String {
                                                    user = NUser.getUser(using: id)
                                                }
                                                if user == nil {
                                                    user = NUser.init(entity: NSEntityDescription.entity(forEntityName: "NUser", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                    user!.parse(json: diveGuideJson)
                                                }
                                                user!.parse(json: diveGuideJson)
                                                users!.append(user!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: users, error: nil))
                                }
        })
    }
}
