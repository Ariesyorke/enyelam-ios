//
//  BookingListController.swift
//  Nyelam
//
//  Created by Bobi on 5/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIScrollView_InfiniteScroll

class BookingListController: BaseViewController, IndicatorInfoProvider {
    @IBOutlet weak var noPurchaseLabel: UILabel!
    
    static func createBookingList(bookingType: Int) -> BookingListController {
        let vc = BookingListController(nibName: "BookingListController", bundle: nil)
        vc.bookingType = bookingType
        return vc
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    fileprivate var summaries: [NSummary]?
    fileprivate var bookingType: Int = 1
    fileprivate var page: Int = 1
    fileprivate let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.tableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: "BookingCell")
        self.tryGetBookingList(bookingType: self.bookingType)
        self.tableView.addInfiniteScroll(handler: {tableView in
            self.tryGetBookingList(bookingType: self.bookingType)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.bookingType == 1 ? "Upcoming" : "Past")
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.page = 1
        self.summaries = []
        self.tableView.reloadData()
        self.tryGetBookingList(bookingType: self.bookingType)
    }
    
    fileprivate func tryGetBookingList(bookingType: Int) {
        NHTTPHelper.httpBookingHistory(page: String(self.page), type: String(bookingType), complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryGetBookingList(bookingType: bookingType)
                    })
                }
                return
            }
            self.refreshControl.endRefreshing()
            self.loadingView.isHidden = true
            if let data = response.data {
                self.noPurchaseLabel.isHidden = true
                self.page += 1
                if self.summaries == nil {
                    self.summaries = []
                }
                self.summaries!.append(contentsOf: data)
                self.tableView.reloadData()
            }
            if self.summaries == nil || self.summaries!.isEmpty {
                self.noPurchaseLabel.isHidden = false
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

extension BookingListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let summary = self.summaries![indexPath.row]
        let _ = BookingDetailController.push(on: self.navigationController!, bookingId: summary.id!, type: String(self.bookingType))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.summaries != nil ? self.summaries!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCell
        let row = indexPath.row
        let summary = self.summaries![row]
        cell.initData(summary: summary)
        return cell
    }
    
}

class BookingCell: NTableViewCell {
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var diveCenterNameLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initData(summary: NSummary) {
        if let diveService = summary.diveService {
            self.serviceNameLabel.text = diveService.name
            if let diveCenter = diveService.divecenter {
                self.diveCenterNameLabel.text = diveCenter.name
            }
        }
        if let order = summary.order {
            self.bookingDateLabel.text = Date(timeIntervalSince1970: order.schedule).formatDate(dateFormat: "dd MMM yyyy")
            self.priceLabel.text = order.cart!.total.toCurrencyFormatString(currency: "Rp")
        }
    }
    
}

