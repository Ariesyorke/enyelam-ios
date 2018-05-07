//
//  NTransactionResult.swift
//  Nyelam
//
//  Created by Bobi on 5/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import MidtransKit

class NTransactionResult: NSObject, Parseable {
    private let KEY_STATUS_CODE = "status_code"
    private let KEY_STATUS_MESSAGE = "status_message"
    private let KEY_TRANSACTION_ID = "transaction_id"
    private let KEY_MASKED_CARD = "masked_card"
    private let KEY_ORDER_ID = "order_id"
    private let KEY_GROSS_AMOUNT = "gross_amount"
    private let KEY_PAYMENT_TYPE = "payment_type"
    private let KEY_TRANSACTION_TIME = "transaction_time"
    private let KEY_TRANSACTION_STATUS = "transaction_status"
    private let KEY_FRAUD_STATUS = "fraud_status"
    private let KEY_FROM = "from"
    
    var statusCode: String = ""
    var statusMessage: String = ""
    var transactionId: String = ""
    var maskedCard: String = ""
    var orderId: String = ""
    var grossAmount: String = ""
    var paymentType: String = ""
    var transactionTime: String = ""
    var transactionStatus: String = ""
    var fraudStatus: String = ""
    var from: String = "mobile"
    
    init(transactionData: MidtransTransactionResult, fraudStatus: String) {
        super.init()
        self.statusCode = String(transactionData.statusCode)
        self.statusMessage = transactionData.statusMessage
        self.transactionId = transactionData.transactionId
//        self.maskedCard = transactionData.maskedCreditCard.maskedNumber
        self.orderId = transactionData.orderId
        self.grossAmount = String(describing: transactionData.grossAmount)
        self.paymentType = transactionData.paymentType
        self.transactionTime = String(transactionData.transactionTime.timeIntervalSince1970)
        self.transactionStatus = transactionData.transactionStatus
        self.fraudStatus = fraudStatus
    }
    func parse(json: [String : Any]) {
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json[KEY_STATUS_CODE] = self.statusCode
        json[KEY_STATUS_MESSAGE] = self.statusMessage
        json[KEY_TRANSACTION_ID] = self.transactionId
        json[KEY_MASKED_CARD] = self.maskedCard
        json[KEY_ORDER_ID] = self.orderId
        json[KEY_GROSS_AMOUNT] = self.grossAmount
        json[KEY_PAYMENT_TYPE] = self.paymentType
        json[KEY_TRANSACTION_TIME] = self.transactionTime
        json[KEY_TRANSACTION_STATUS] = self.transactionStatus
        json[KEY_FRAUD_STATUS] = self.fraudStatus
        json[KEY_FROM] = self.from
        return json
    }
    
    
}
