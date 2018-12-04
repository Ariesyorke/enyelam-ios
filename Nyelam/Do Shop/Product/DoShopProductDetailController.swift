//
//  DoShopProductDetailController.swift
//  Nyelam
//
//  Created by Bobi on 11/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD
import ActionSheetPicker_3_0
import PopupController

class DoShopProductDetailController: BaseViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var product: NProduct?
    fileprivate var relatedProducts: [NProduct]?
    fileprivate var refreshControl: UIRefreshControl = UIRefreshControl()
    fileprivate var qty: Int = 1
    fileprivate var pickedVariation: [String: String] = [:]

    var productId: String?
    
    static func push(on controller: UINavigationController, productId: String) -> DoShopProductDetailController {
        let vc = DoShopProductDetailController(nibName: "DoShopProductDetailController", bundle: nil)
        vc.productId = productId
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProductInfoCell", bundle: nil), forCellReuseIdentifier: "ProductInfoCell")
        self.tableView.register(UINib(nibName: "RelatedProductCell", bundle: nil), forCellReuseIdentifier: "RelatedProductCell")
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(DoShopProductDetailController.onRefresh(_:)), for: UIControlEvents.valueChanged)

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
        self.pickedVariation = [:]
        self.qty = 1
        self.tryLoadProductDetail(productId: self.productId!)
    }
    
    fileprivate func tryLoadProductDetail(productId: String) {
        NHTTPHelper.httpProductDetail(productId: productId, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadProductDetail(productId: productId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                return
            }
            if let data = response.data {
                self.product = data
                print("PANGGIL 1")
                if let nsset = data.categories, let categories = nsset.allObjects as? [NCategory], !categories.isEmpty {
                    print("PANGGIL 2")
                    self.tryRelatedProduct(categoryId: categories[0].id!)
                } else {
                    print("PANGGIL 3")
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            } else {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    fileprivate func tryRelatedProduct(categoryId: String) {
        NHTTPHelper.httpGetProductList(page: 1, keyword: nil, categoryId: categoryId, priceMin: nil, priceMax: nil, sortBy: nil, merchantId: nil, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryRelatedProduct(categoryId: categoryId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
            }

            if let data = response.data, let datas = data.products, !datas.isEmpty {
                self.relatedProducts = datas
            }
            self.tableView.reloadData()
        })
    }
    
    fileprivate func tryAddToCart(productId: String, pickedVariations: [String: String], qty: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var variations: [String]? = nil
        for (_, value) in pickedVariations {
            if variations == nil {
                variations = []
            }
            variations!.append(value)
        }
        NHTTPHelper.httpAddToCartRequest(productId: productId, qty: qty, variations: variations, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryAddToCart(productId: productId, pickedVariations: pickedVariations, qty: qty)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        _ = error as! StatusFailedError
                    })
                }
                return
            }
            self.createCartPopup(product: self.product!)
        })
    }
    
    fileprivate func createCartPopup(product: NProduct) {
        let popupWidth = UIScreen.main.bounds.width - 32
        let imageH = CGFloat(popupWidth - 16)
        let titleH = CGFloat(48)
        let bottomH = CGFloat(112)
        let popupSize = CGSize(width: popupWidth, height: imageH + titleH + bottomH)
        let addedToCartController = AddedToCartController.create(product: product, size: popupSize)
        let popup = PopupController.create(self.navigationController!).customize(
            [
                .animation(.fadeIn),
                .backgroundStyle(.blackFilter(alpha: 0.7)),
                .dismissWhenTaps(false),
                .layout(.center)
            ])
        
        _ = popup.show(addedToCartController)
        addedToCartController.onGoToCart = {
            popup.dismiss({
                let _ = CartController.push(on: self.navigationController!)
            })
        }
        addedToCartController.onContinueShopping = {
            popup.dismiss({
                
            })
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

extension DoShopProductDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let _ = self.product {
            count += 1
        }
        if let products = self.relatedProducts, !products.isEmpty {
            if products.count > 2 {
                count += 2
            } else {
                count += products.count
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoCell", for: indexPath)
            as! ProductInfoCell
            cell.initData(product: self.product!, qty: self.qty, controllerView: self.view)
            cell.onVariationTriggered = {variation, variationView in
                self.openVariation(variation: variation, sender: variationView)
            }
            cell.onAddToCart = {
                if let authUser = NAuthReturn.authUser() {
                    self.tryAddToCart(productId: self.productId!, pickedVariations: self.pickedVariation, qty: self.qty)
                } else {
                    self.goToAuth(completion: {
                        if let authUser = NAuthReturn.authUser() {
                            self.tryAddToCart(productId: self.productId!, pickedVariations: self.pickedVariation, qty: self.qty)
                        }
                    })
                }
            }
            cell.onUpdateQuantity = {qty in
                self.qty = qty
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedProductCell", for: indexPath) as! RelatedProductCell
            cell.onSeeAllProduct = {
                if let nsset = self.product!.categories, let categories = nsset.allObjects as? [NProductCategory], !categories.isEmpty {
                    let filter = DoShopFilter()
                    filter.categoryId = categories[0].id
                    let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                }
            }
            return cell
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        })
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func openVariation(variation: Variation, sender: NVariationView) {
        if let variationItems = variation.variationItems, !variationItems.isEmpty {
            var v: [String] = []
            for variationItem in variationItems {
                v.append(variationItem.name!)
            }
            let actionSheet = ActionSheetStringPicker.init(title: variation.key, rows: v, initialSelection: 0, doneBlock: {picker, index, value in
                self.pickedVariation[variation.key!] = variationItems[index].id!
                sender.variationNameLabel.text = variationItems[index].name!
            }, cancel: {_ in return
                
            }, origin: sender)
            actionSheet!.show()
        }
    }
    
}
