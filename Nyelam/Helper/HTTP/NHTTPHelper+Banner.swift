//
//  NHTTPHelper+Banner.swift
//  Nyelam
//
//  Created by Bobi on 6/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire

extension NHTTPHelper {
    static func httpGetBanner(complete: @escaping (NHTTPResponse<[Banner]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_BANNER, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var banners: [Banner]? = nil
                if let bannerArray = json["banners"] as? Array<[String: Any]>, !bannerArray.isEmpty {
                    banners = []
                    for bannerJson in bannerArray {
                        var type = -1
                        if let t = bannerJson["id"] as? Int {
                            type = t
                        } else if let t = bannerJson["id"] as? String {
                            if t.isNumber {
                                type = Int(t)!
                            }
                        }
                        if type == 1 {
                            let banner = ServiceBanner(json: bannerJson)
                            banners!.append(banner)
                        } else if type == 2 {
                            let banner = URLBanner(json: bannerJson)
                            banners!.append(banner)
                        } else {
                            let banner = Banner(json: bannerJson)
                            banners!.append(banner)
                        }
                    }
                } else if let bannerString = json["banners"] as? String {
                    do {
                        let data = bannerString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let bannerArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        banners = []
                        for bannerJson in bannerArray {
                            var type = -1
                            if let t = bannerJson["type"] as? Int {
                                type = t
                            } else if let t = bannerJson["type"] as? String {
                                if t.isNumber {
                                    type = Int(t)!
                                }
                            }
                            if type == 1 || type == 3 {
                                let banner = ServiceBanner(json: bannerJson)
                                banners!.append(banner)
                            } else if type == 2 {
                                let banner = URLBanner(json: bannerJson)
                                banners!.append(banner)
                            } else {
                                let banner = Banner(json: bannerJson)
                                banners!.append(banner)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        })
    }
}
