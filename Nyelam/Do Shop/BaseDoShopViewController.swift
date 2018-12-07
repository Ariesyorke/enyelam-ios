//
//  BaseDoShopViewController.swift
//  Nyelam
//
//  Created by Bobi on 07/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class BaseDoShopViewController: BaseViewController {
    fileprivate var cartButton: UIBarButtonItem!
    
    fileprivate func tryLoadCartList() {
        NHTTPHelper.httpCartListRequest(complete: {response in
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
            if let data = response.data, let cart = data.cart, let merchants = cart.merchants {
                var count = 0
                for merchant in merchants {
                    if let products = merchant.products, !products.isEmpty {
                        count += products.count
                   }
                }
                self.cartButton.badgeValue = String(describing: count)
                return
            } else {
                self.cartButton.badgeValue = ""
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartButton = UIBarButtonItem(image: UIImage(named: "ic_cart"), style: .plain, target: self, action: #selector(BaseDoShopViewController.onCart(_:)))
        self.navigationItem.rightBarButtonItem = self.cartButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let authUser = NAuthReturn.authUser() {
            self.tryLoadCartList()
        }
    }
    
    @objc func onCart(_ sender: UIBarButtonItem) {
        if let authUser = NAuthReturn.authUser() {
            let _ = CartController.push(on: self.navigationController!)
        } else {
            self.goToAuth(completion: {
                let _ = CartController.push(on: self.navigationController!)
            })
        }
    }
}
