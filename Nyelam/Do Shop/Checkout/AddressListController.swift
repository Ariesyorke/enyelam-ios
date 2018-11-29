//
//  AddressListController.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import UINavigationControllerWithCompletionBlock

class AddressListController: BaseViewController {
    var type: String = "billing"
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var addresses: [NAddress]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var completion: (NAddress, Bool) -> () = {address, sameasbilling in }
    
    static func push(on controller: UINavigationController, type: String, completion: @escaping (NAddress, Bool)->()) -> AddressListController {
        let vc = AddressListController(nibName: "AddressListController", bundle: nil)
        vc.completion = completion
        vc.type = type
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        self.tableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "ic_add_plus_button"), style: .plain, target: self, action: #selector(addButtonAction(_:))), animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        }
    }

    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.addresses = nil
        self.tableView.reloadData()
        self.tryLoadAddress(type: self.type)
    }
    
    fileprivate func tryLoadAddress(type: String) {
        NHTTPHelper.httpAddressListRequest(type: type, complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadAddress(type: type)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.addresses = datas
            }
        })
    }
    @objc func addButtonAction(_ sender: UIBarButtonItem) {
        let _ = AddAddressViewController.push(on: self.navigationController!, defaultShipping: type == "shipping" ? 1 : 0, defaultBillng: type == "billing" ? 1 : 0, successCompletion: {sameasbiiling, address in
            self.navigationController!.popViewController(animated: true, withCompletionBlock: {
                self.completion(address, sameasbiiling)
            })
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

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = self.addresses![indexPath.row]
        self.navigationController!.popViewController(animated: true, withCompletionBlock: {
            self.completion(address, false)
        })
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let address = self.addresses![indexPath.row]
        cell.initData(address: address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addresses = addresses, !addresses.isEmpty {
            return addresses.count
        }
        return 0
    }
}
