//
//  NHTTPHelper+Notification.swift
//  Nyelam
//
//  Created by Bobi on 5/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension NHTTPHelper {
    static func httpPaypalNotification(paypalId: String, complete: @escaping (NHTTPResponse<Bool>)->()) {
        self.basicPostRequest(URLString: API_PATH_PAYPAL_NOTIFICATION,
                              parameters: ["paypal_id":paypalId],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                complete(NHTTPResponse(resultStatus: true, data: true, error: nil))
        })
    }
    static func httpVeritransNotification(parameters: [String: Any], complete: @escaping (NHTTPResponse<Bool>)->()) {
        Alamofire.request(API_VERITRANS_PAYPAL_NOTIFICATION, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            if let error = response.error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    complete(NHTTPResponse(resultStatus: false, data: false, error:  NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: "")))
                }
                return
            }
            complete(NHTTPResponse(resultStatus: true, data: true, error: nil))
        })
        
    }
}
