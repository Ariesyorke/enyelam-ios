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
    
    static func httpGetMinMaxPrice(type: String) {
        
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
