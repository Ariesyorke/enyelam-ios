//
//  InboxController.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class InboxController: BaseViewController {
    var inboxes: [Inbox]?
    var page: Int = 1
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initView() {
        let margin = UIEdgeInsetsMake(8, 0, 8, 0)
        self.tableView.contentInset = margin
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
        self.tableView.addInfiniteScroll(handler: self.infiniteScroll)
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Please wait")
        self.refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl!)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.firstTime {
            self.firstTime = false
            self.tryLoadInboxList()
        }
    }
    
    fileprivate func tryLoadInboxList() {
        NHTTPHelper.httpGetInbox(page: page, complete: {response in
            self.loadingView.isHidden = true
            self.refreshControl!.endRefreshing()
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.tryLoadInboxList()
                        })
                    }
                })
                return
            }
            self.tableView.finishInfiniteScroll()
            if let datas = response.data, !datas.isEmpty {
                self.initInboxes(inboxes: datas)
            }
        })
    }

    func infiniteScroll(tableview: UITableView) -> () {
        self.tryLoadInboxList()
    }
    
    fileprivate func initInboxes(inboxes: [Inbox]) {
        self.loadingView.isHidden = true
        self.page += 1
        if self.inboxes == nil {
            self.inboxes = []
        }
        self.inboxes!.append(contentsOf: inboxes)
        self.tableView.reloadData()
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl!.beginRefreshing()
        self.page = 1
        self.inboxes = []
        self.tableView.reloadData()
        self.tryLoadInboxList()
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

extension InboxController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxCell
        let inbox = self.inboxes![indexPath.row]
        cell.initData(inbox: inbox)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let inboxes = self.inboxes, !inboxes.isEmpty {
            count += inboxes.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inbox = self.inboxes![indexPath.row]
        var closed = true
        if let status = inbox.status, status.lowercased() == "open" {
            closed = false
        }
        if let authReturn = NAuthReturn.authUser(), let user = authReturn.user {
            InboxDetailController.push(on: self.navigationController!, inbox: inbox, senderId: user.id!, closed: closed)
        }

    }
}



