//
//  CartController.swift
//  Nyelam
//
//  Created by Bobi on 11/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class CartController: BaseViewController {
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var cartReturn: CartReturn? {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    static func push(on controller: UINavigationController) -> CartController {
        let vc = CartController(nibName: "CartController", bundle: nil)
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
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.onRefresh(self.refreshControl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        
    }
    
    fileprivate func tryLoadCartList() {
        NHTTPHelper.cartListRequest(complete: {response in
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
            }
        })
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let cartReturn = self.cartReturn,
            let cart = cartReturn.cart,
            let merchants = cart.merchants, !merchants.isEmpty {
            if section == 0 {
                return 50
            } else {
                let index = section - 1
                if index < merchants.count {
                    return 50
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
                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                view.backgroundColor = UIColor.darkGray
                return view
            } else {
                let index = section - 1
                if index < merchants.count {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                    view.backgroundColor = UIColor.white
                    return view
                }
            }
        }
        return UIView()
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
                var index = indexPath.section - 1
                if index < merchants.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
                    return cell
                } else if index == merchants.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCodeCell", for: indexPath) as! VoucherCodeCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCartCell", for: indexPath) as! SummaryCartCell
                }
            }
        }
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
