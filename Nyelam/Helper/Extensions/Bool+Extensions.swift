//
//  Bool+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

extension Bool {
    var number: Int {
        if self {
            return 1
        } else {
            return 0
        }
    }
}
