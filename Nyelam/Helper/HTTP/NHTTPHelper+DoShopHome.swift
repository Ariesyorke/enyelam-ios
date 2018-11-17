//
//  NHTTPHelper+DoShopHome.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreData

extension NHTTPHelper {
    static func httpGetFeaturedDoShop(complete: @escaping (NHTTPResponse<DoShopRecommended>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_RECOMMENDED_SHOP, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                complete(NHTTPResponse(resultStatus: true, data: DoShopRecommended(json: json), error: nil))
            }
        })
    }
}
