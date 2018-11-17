//
//  NHTTPHelper+Address.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

extension NHTTPHelper {
    static func httpAddressListRequest(complete: @escaping (NHTTPResponse<[NAddress]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_ADDRESS_LIST, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let addresses: [NAddress]? = nil
                if let addressesArray = json["addresses"] as? Array<[String: Any]>, !addressesArray.isEmpty {
                    
                } else if let addressesArrayString = json["addresses"] as? String {
                    
                }
                complete(NHTTPResponse(resultStatus: true, data: addresses, error: nil))
            }

        })
    }
}
