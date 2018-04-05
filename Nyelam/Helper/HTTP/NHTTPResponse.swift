//
//  NHTTPResponse.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public struct GAHTTPResponse<Data> {
    public let resultStatus: Bool!
    public var data: Data?
    public let error: BaseError?
    
    public init(resultStatus: Bool, data: Data?, error: BaseError?) {
        self.resultStatus = resultStatus
        self.data = data
        self.error = error
    }
}
