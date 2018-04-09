//
//  NHTTPHelper+General.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
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
}
