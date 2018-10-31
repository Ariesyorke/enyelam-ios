//
//  NSDecimalNumber+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 10/30/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    public func round(_ decimals:Int) -> NSDecimalNumber {
        return self.rounding(accordingToBehavior:
            NSDecimalNumberHandler(roundingMode: .up,
                                   scale: Int16(decimals),
                                   raiseOnExactness: false,
                                   raiseOnOverflow: false,
                                   raiseOnUnderflow: false,
                                   raiseOnDivideByZero: false))
    }
}

