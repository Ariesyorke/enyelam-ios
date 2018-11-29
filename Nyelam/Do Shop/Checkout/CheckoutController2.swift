//
//  CheckoutController2.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD

class CheckoutController2: BaseViewController {
    var titles: [String] = ["1. PERSONAL INFORMATIONS", "2. SHIPPING", "3. PAYMENTS", "4. ORDER DETAILS"]
    
    var billingAddress: NAddress?
    var shippingAddress: NAddress?
    var pickedCouriers: [Courier] = []
    var pickedCourierTypes: [CourierType] = []
    
    var cartReturn: CartReturn?

    @IBOutlet weak var tableView: UITableView!
    
    static func push(on controller: UINavigationController, cartReturn: CartReturn) -> CheckoutController2 {
        let vc = CheckoutController2(nibName: "CheckoutController2", bundle: nil)
        vc.cartReturn = cartReturn
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PersonalInformationCell", bundle: nil), forCellReuseIdentifier: "PersonalInformationCell")
        self.tableView.register(UINib(nibName: "CheckoutProgressCell", bundle: nil), forCellReuseIdentifier: "CheckoutProgressCell")
        self.tableView.register(UINib(nibName: "CourierCell", bundle: nil), forCellReuseIdentifier: "CourierCell")
        self.tableView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        self.tableView.register(UINib(nibName: "CheckoutSummaryCell", bundle: nil), forCellReuseIdentifier: "CheckoutSummaryCell")
        self.title = "Checkout"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = true
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.tryLoadAddress(type: "billing", completion: {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tryLoadAddress(type: "shipping", completion: {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                })
            })
        }
    }
    func tryLoadAddress(type: String, completion: @escaping () -> ()) {
        NHTTPHelper.httpAddressListRequest(type: type, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadAddress(type: type, completion: completion)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.findDefaultAddresses(addresses: datas, type: type)
            }
            completion()
        })
    }
    
    fileprivate func findDefaultAddresses(addresses: [NAddress], type: String) {
        for address in addresses {
            if type == "shipping" {
                if address.default_shipping == Int16(1) {
                    self.shippingAddress = address
                    break
                }
            }
            
            if type == "billing" {
                if address.default_billling == Int16(1) {
                    self.billingAddress = address
                    break
                }
            }
        }
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

extension CheckoutController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }

        let view = NCartHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 33))
        view.titleLabel.text = self.titles[section - 1]
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 33
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            if let cartReturn = self.cartReturn, let cart = cartReturn.cart, let merchants = cart.merchants {
                return merchants.count
            }
            return 0
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutProgressCell", for: indexPath) as! CheckoutProgressCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInformationCell", for: indexPath) as! PersonalInformationCell
            if cell.row == 0 {
                if let billingAddress = self.billingAddress {
                    cell.initData(address: billingAddress)
                }
            } else if cell.row == 1 {
                if let shippingAddress = self.shippingAddress {
                    cell.initData(address: shippingAddress)
                }
            }
            cell.onChangeAddress = {row in
                let _ = AddressListController.push(on: self.navigationController!, type: row == 0 ? "billing" : "shipping", completion: {address, sameasbilling in
                    if row == 0 {
                        self.billingAddress = address
                    } else {
                        self.shippingAddress = address
                    }
                    if sameasbilling {
                        self.shippingAddress = address
                    }
                    self.tableView.reloadRows(at: [IndexPath(row: 0, col: 1), IndexPath(row: 1, col: 1)], with: .automatic)
                })
            }
            cell.row = indexPath.row
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourierCell", for: indexPath) as! CourierCell
            let courierType: CourierType? = !self.pickedCourierTypes.isEmpty ? self.pickedCourierTypes[indexPath.row] : nil
            let courier: Courier? = !self.pickedCourierTypes.isEmpty ? self.pickedCouriers[indexPath.row] : nil

            cell.initData(merchant: self.cartReturn!.cart!.merchants![indexPath.row], courier: courier, courierType: courierType)
            cell.onChangeCourier = {row in
                
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutSummaryCell", for: indexPath) as! CheckoutSummaryCell
            return cell
        }
        return UITableViewCell()
    }
}
