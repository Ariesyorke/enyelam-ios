//
//  OrderListController.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OrderListController: BaseViewController, IndicatorInfoProvider {
    private let orderStatuses: [String] = ["Pending", "Waiting for Payment", "Payment Accepted", "Payment Declined", "Order Canceled", "Order Processed", "Order Sent", "Order Closed"]
    var bookingType: Int = 1
    
    static func create(bookingType: Int) -> OrderListController {
        let vc = OrderListController(nibName: "OrderListController", bundle: nil)
        vc.bookingType = bookingType
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.orderStatuses[self.bookingType - 1])
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
