//
//  PriceRangeManager.swift
//  Nyelam
//
//  Created by Bobi on 4/25/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class PriceRangeManager {
    var doDivePriceRange: Price = Price(lowestPrice: 50000, highestPrice: 10000000)
    var doTripPriceRange: Price = Price(lowestPrice: 50000, highestPrice: 10000000)
    private static var _instance: PriceRangeManager?
    
    static var shared: PriceRangeManager {
        if _instance == nil {
            _instance = PriceRangeManager()
        }
        return _instance!
    }
    
}
