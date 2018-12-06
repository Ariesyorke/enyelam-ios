//
//  CartController.swift
//  Nyelam
//
//  Created by Bobi on 11/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MBProgressHUD

class CartController: BaseViewController {
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var cartReturn: CartReturn? {
        didSet {
            if let _ = self.cartReturn {
                self.checkoutButton.isHidden = false
                self.tableView.reloadData()
            } else {
                self.checkoutButton.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    static func push(on controller: UINavigationController) -> CartController {
        let vc = CartController(nibName: "CartController", bundle: nil)
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProductCartCell", bundle: nil), forCellReuseIdentifier: "ProductCartCell")
        self.tableView.register(UINib(nibName: "VoucherCodeCell", bundle: nil), forCellReuseIdentifier: "VoucherCodeCell")
        self.tableView.register(UINib(nibName: "SummaryCartCell", bundle: nil), forCellReuseIdentifier: "SummaryCartCell")
        self.tableView.register(UINib(nibName: "ProductTitleCartCell", bundle: nil), forCellReuseIdentifier: "ProductTitleCartCell")
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(CartController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.title = "Cart"
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.checkoutButton.isHidden = true
        self.tryLoadCartList()
    }
    
    fileprivate func tryLoadCartList() {
        NHTTPHelper.httpCartListRequest(complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCartList()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                return
            }
            if let data = response.data {
                self.cartReturn = data
            } else {
                self.checkoutButton.isHidden = true
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
        let _ = CheckoutController2.push(on: self.navigationController!, cartReturn: self.cartReturn!)
    }
    
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            if section == 0 {
                return 33
            } else {
                let index = section - 1
                if index < merchants.count || index > merchants.count {
                    return 1
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            if section == 0 {
                let view = NCartHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 33))
                view.titleLabel.text = "ORDER DETAILS"
                return view
            }
//            else {
//                let index = section - 1
//                if index < merchants.count {
//                    let view = NCartHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 33))
//                    view.titleLabel.text = merchants[index].merchantName?.uppercased()
//                    return view
//                } else if index > merchants.count {
//                    let view = NCartHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 33))
//                    view.titleLabel.text = "SUMMARY"
//                    return view
//
//                }
//            }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        view.backgroundColor = UIColor.white
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            if section == 0 {
                return 1
            } else {
                let index = section - 1
                if index < merchants.count {
                    let products = merchants[index].products
                    if let products = products, !products.isEmpty {
                        return products.count
                    }
                } else {
                    return 1
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTitleCartCell", for: indexPath) as! ProductTitleCartCell
                return cell
            } else {
                let index = indexPath.section - 1
                if index < merchants.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
                    cell.initData(product: merchants[index].products![indexPath.row])
                    cell.onChangeQuantity = {qty in
                        self.changeQuantity(quantity: qty, productCartId: merchants[index].products![indexPath.row].productCartId!)
                    }
                    cell.onDeleteButton = {productCartId in
                        UIAlertController.showAlertWithMultipleChoices(title: "Are you sure want to delete this product?", message: nil, viewController: self, buttons: [UIAlertAction(title: "Yes", style: .default, handler: {action in
                            self.tryDeleteProductCart(productCartId: productCartId)
                        }),UIAlertAction(title: "No", style: .cancel, handler: nil)])
                    }
                    return cell
                } else if index == merchants.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCodeCell", for: indexPath) as! VoucherCodeCell
                    if let voucher =  cart.voucher {
                        cell.initData(voucher: voucher)
                    }
                    cell.onApplyVoucherCode = {voucherCode in
                        self.view.endEditing(true)
                        if voucherCode.isEmpty {
                            UIAlertController.handleErrorMessage(viewController: self, error: "Vouche code cannot be empty!", completion: {})
                            return
                        }
                        self.tryAddVoucher(voucherCode: voucherCode)
                    }
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCartCell", for: indexPath) as! SummaryCartCell
                    cell.initData(cart: self.cartReturn!.cart!, additionals: self.cartReturn!.additionals)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    fileprivate func tryDeleteProductCart(productCartId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpDeleteProductCart(productCartId: [productCartId], complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCartList()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                return
            }
            if let data = response.data {
                self.cartReturn = data
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    fileprivate func tryAddVoucher(voucherCode: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpDoShopAddVoucherRequest(cartToken: self.cartReturn!.cartToken!, voucherCode: voucherCode, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCartList()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                self.tableView.reloadData()
                return
            }
            if let data = response.data {
                self.cartReturn = data
            }
        })
    }
    fileprivate func changeQuantity(quantity: Int, productCartId: String) {
        var quantities: [String] = []
        for var i in 0..<31 {
            quantities.append(String(i+1))
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Change Quantity", rows: quantities, initialSelection: quantity-1, doneBlock: {picker, index, value in
            
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func tryChangeCart(productCartId: String, quantity: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpChangeCartQuantityRequest(productCartId: productCartId, qty: String(quantity), complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCartList()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                return
            }
            if let data = response.data {
                self.cartReturn = data
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var section = 0
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            section = 3 + merchants.count
        }
        return section
    }
    
}
