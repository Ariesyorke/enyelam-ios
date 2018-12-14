//
//  OrderDetailController.swift
//  Nyelam
//
//  Created by Bobi on 12/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderDetailController: BaseViewController {
    private let sections = ["Your Order ID:", "Order Info", "Payment"]

    var orderId: String?
    var order: NOrder? {
        didSet {
            if let _ = self.order {
                self.tableView.reloadData()
            }
        }
    }
    var isComeFromOrder: Bool = false
    
    fileprivate let refreshControl: UIRefreshControl = UIRefreshControl()
    fileprivate let picker = UIImagePickerController()
    
    @IBOutlet weak var tableView: UITableView!

    static func push(on controller: UINavigationController, orderId: String) -> OrderDetailController {
        let vc = OrderDetailController(nibName: "OrderDetailController", bundle: nil)
        vc.orderId = orderId
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, orderId: String, isComeFromOrder: Bool) -> OrderDetailController {
        let vc: OrderDetailController = OrderDetailController(nibName: "OrderDetailController", bundle: nil)
        vc.orderId = orderId
        vc.isComeFromOrder = isComeFromOrder
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        self.tableView.register(UINib(nibName: "OrderInfoCell", bundle: nil), forCellReuseIdentifier: "OrderInfoCell")
        self.tableView.register(UINib(nibName: "PaymentProofCell", bundle: nil), forCellReuseIdentifier: "PaymentProofCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.tableView.addSubview(self.refreshControl)
            self.refreshControl.addTarget(self, action: #selector(OrderDetailController.onRefresh(_:)), for: UIControlEvents.valueChanged)
            self.title = "Order Detail"
            self.onRefresh(self.refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.tryLoadOrderDetail(orderId: self.orderId!)
    }

    
    
    override func backButtonAction(_ sender: UIBarButtonItem) {
        if self.isComeFromOrder {
            if let navigation = self.navigationController {
                self.moveSafeAreaInsets()
                navigation.popToRootViewController(animated: true)
            }
        } else {
            super.backButtonAction(sender)
        }
    }
    
    fileprivate func uploadProof(data: Data, bookingId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpUploadPaymentProof(data: data, bookingDetailId: bookingId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.uploadProof(data: data, bookingId: bookingId)
                   })
                }
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Upload Success!", actionButtonTitle: "OK", completion: {
                
            })
        })
    }

    fileprivate func tryLoadOrderDetail(orderId: String) {
        NHTTPHelper.httpDoShopOrderDetailRequest(orderId: orderId, complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadOrderDetail(orderId: orderId)
                    })
                }
                return
            }
            if let data = response.data {
                self.order = data
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

extension OrderDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle = NBookingTitleSection(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        if section == 0 {
            sectionTitle.subtitleLabel.isHidden = false
        } else {
            sectionTitle.subtitleLabel.isHidden = true
        }
        sectionTitle.titleLabel.text = self.sections[section]
        if section == 0 {
            sectionTitle.titleLabel.text = "\(sectionTitle.titleLabel.text!) #\(self.order!.orderId!)"
            sectionTitle.subtitleLabel.text = self.order!.status
        }
        return sectionTitle
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let order = self.order, let cart = order.cart, let merchants = cart.merchants, !merchants.isEmpty {
            if section == 0 {
                return 1
            } else if section == 1 {
                return merchants.count
            } else if section == 2 {
                return 1
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let order = self.order {
            var section = 2
            if let status = order.status, status.lowercased() == "pending" || status.lowercased() == "waiting for payment", order.veritransToken == nil && order.paypalCurrency == nil {
                section += 1
            }
            return section
        }
        return 0

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell") as! OrderSummaryCell
            cell.initData(cart: self.order!.cart!, merchants: self.order!.cart!.merchants!, voucher: self.order!.cart!.voucher, additionals: self.order!.additionals, date: self.order!.orderDate as? Date)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoCell") as! OrderInfoCell
            cell.initData(merchant: self.order!.cart!.merchants![indexPath.row])
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentProofCell") as! PaymentProofCell
            cell.onChangePhoto = {
                UIAlertController.showAlertWithMultipleChoices(title: "Change Profile Photo", message: nil, viewController: self, buttons: [
                    UIAlertAction(title: "Gallery", style: .default, handler: {alert in
                        self.picker.sourceType = .photoLibrary
                        self.picker.delegate = self
                        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        self.present(self.picker, animated: true, completion: nil)
                    }),
                    UIAlertAction(title: "Take Photo", style: .default, handler: {alert in
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.picker.sourceType = UIImagePickerControllerSourceType.camera
                            self.picker.cameraCaptureMode = .photo
                            self.picker.delegate = self
                            self.picker.modalPresentationStyle = .fullScreen
                            self.present(self.picker,animated: true,completion: nil)
                        } else {
                            UIAlertController.handleErrorMessage(viewController: self, error: "Sorry this device has no camera", completion: {})
                        }
                    }),
                    UIAlertAction(title: "Cancel", style: .default, handler: {alert in
                        
                    })
                 ])
            }
            return cell
        }
        return  UITableViewCell()
    }
}

extension OrderDetailController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImageJPEGRepresentation(chosenImage, 0.75)
            self.dismiss(animated: true, completion: {
                self.uploadProof(data: data!, bookingId: self.orderId!)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

