//
//  NHTTPHelper+EcoTrip.swift
//  Nyelam
//
//  Created by Bobi on 6/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire

extension NHTTPHelper {
    static func httpGetEcoTripCalendar(complete: @escaping (NHTTPResponse<[Int]>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_ECO_TRIP_CALENDAR, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            
            if let data = data, let json = data as? [String: Any] {
                var timestamps: [Int]? = nil
                if let array = json["schedule"] as? Array<Int>, !array.isEmpty {
                    timestamps = []
                    for timestamp in array {
                        timestamps!.append(timestamp)
                    }
                } else if let array = json["schedule"] as? Array<String>, !array.isEmpty {
                    timestamps = []
                    for timestamp in array {
                        if timestamp.isNumber {
                            timestamps!.append(Int(timestamp)!)
                        }
                    }
                } else if let scheduleString = json["schedule"] as? String {
                    do {
                        var data = scheduleString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let array: Array<Int> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<Int>
                        timestamps = []
                        for timestamp in array {
                            timestamps!.append(timestamp)
                        }
                    } catch {
                        print(error)
                    }
                }
                timestamps?.sort()
                complete(NHTTPResponse(resultStatus: true, data: timestamps, error: nil))
            }
        })
    }
}
