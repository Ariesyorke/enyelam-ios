//
//  TransactionResult.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class TransactionResult {
    var statusCode: Int?
    var statusMessage: String?
    var transactionId: String?
    var maskedCard: String?
    var orderId: String?
    var grossAmount: String?
    var paymentType: String?
    var transactionTime: String?
    var transactionStatus: String?
    var fraudStatus: String?
    var approvalCode: String?
    var from: String = "mobile"
    var secureToken: Bool?
    
}
