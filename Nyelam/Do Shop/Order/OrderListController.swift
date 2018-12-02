//
//  OrderListController.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIScrollView_InfiniteScroll

class OrderListController: BaseViewController, IndicatorInfoProvider {
    private let orderStatuses: [String] = ["Pending", "Waiting for Payment", "Payment Accepted", "Payment Declined", "Order Canceled", "Order Processed", "Order Sent", "Order Closed"]
    var paymentType: Int = 1
    var page: Int = 1
    fileprivate var orders: [NOrder]?

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    static func create(paymentType: Int) -> OrderListController {
        let vc = OrderListController(nibName: "OrderListController", bundle: nil)
        vc.paymentType = paymentType
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        self.refreshControl.addTarget(self, action: #selector(OrderListController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.tableView.addSubview(self.refreshControl)
        self.tableView.addInfiniteScroll(handler: {scrollView in
            
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.orderStatuses[self.paymentType - 1])
    }

    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.page = 1
        self.orders = []
        self.tableView.reloadData()
        
    }
    
    fileprivate func tryLoadOrderList(paymentType: Int) {
        NHTTPHelper.httpOrderListRequest(paymentType: String(paymentType), page: String(self.page), complete: {response in
            self.refreshControl.endRefreshing()
            self.tableView.finishInfiniteScroll()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadOrderList(paymentType: paymentType)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                    })
                }
            }
            if let datas = response.data, !datas.isEmpty {
                self.page += 1
                if self.orders == nil {
                    self.orders = []
                }
                self.orders!.append(contentsOf: datas)
                self.tableView.reloadData()
            }
        })
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

extension OrderListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orders = self.orders, !orders.isEmpty {
            return orders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = self.orders![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        cell.initData(merchant: order.cart!.merchants![0])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = self.orders![indexPath.row]
        
    }
}
