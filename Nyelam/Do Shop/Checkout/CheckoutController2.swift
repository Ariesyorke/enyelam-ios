//
//  CheckoutController2.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD
import MidtransKit

class CheckoutController2: BaseViewController {
    var titles: [String] = ["1. PERSONAL INFORMATIONS", "2. SHIPPING", "3. PAYMENTS", "4. ORDER DETAILS"]
    
    var billingAddress: NAddress?
    var shippingAddress: NAddress?
    var pickedCouriers: [Courier] = []
    var pickedCourierTypes: [CourierType] = []
    var cartReturn: CartReturn?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    
    fileprivate var grandTotal: Double = -1.0
    fileprivate var payPalConfig = PayPalConfiguration()
    fileprivate var paymentMethodType: Int = 1
    fileprivate var isLoadAdditionalFee: Bool = false
    fileprivate var orderReturn: OrderReturn?

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = true
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.tryLoadAddress(type: "billing", completion: {
                self.tryLoadAddress(type: "shipping", completion: {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
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
    
    fileprivate func calculateGrandTotal() {
        if let cartReturn = self.cartReturn, let cart = cartReturn.cart {
            self.grandTotal += cart.total
            if !self.pickedCourierTypes.isEmpty, self.pickedCourierTypes.count == cart.merchants!.count {
                for pickedPickedType in self.pickedCourierTypes {
                    if let costs = pickedPickedType.costs, !costs.isEmpty {
                        self.grandTotal += Double(costs[0].value)
                    }
                }
                self.priceLabel.text = self.grandTotal.toCurrencyFormatString(currency: "Rp")
                self.payNowButton.isEnabled = true
                self.payNowButton.backgroundColor = UIColor.primary
            }
        } else {
            self.grandTotal = -1.0
        }
    }
    
    @IBAction func payButtonAction(_ sender: Any) {
        if self.grandTotal < 0 {
            UIAlertController.handleErrorMessage(viewController: self, error: "Make sure you complete your data including shipping address, billing address, courier", completion: {})
            return
        }
        if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let order = summary.order {
            
        } else if let cartReturn = self.cartReturn {
            
        }
    }
    
    fileprivate func trySubmitOrder(shippingAddressId: String, billingAddressId: String, paymentMethodId: String, cartToken: String, deliveryServiceHasmap: [String: String], voucherCode: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpDoShopSubmitOrderRequest(paymentMethodId: paymentMethodId, cartToken: cartToken, billingAddressId: billingAddressId, shippingAddressId: shippingAddressId, deliveryServiceMapping: deliveryServiceHasmap, voucherCode: voucherCode, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.trySubmitOrder(shippingAddressId: shippingAddressId, billingAddressId: billingAddressId, paymentMethodId: paymentMethodId, cartToken: cartToken, deliveryServiceHasmap: deliveryServiceHasmap, voucherCode: voucherCode)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                    })
                }
                return
            }
            if let data = response.data {
                self.orderReturn = data
                self.handlePaymentMethodType(orderReturn: data, paymentType: paymentMethodId)
            }
        })
    }
    
    fileprivate func handlePaymentMethodType(orderReturn: OrderReturn, paymentType: String) {
        if paymentType == "2" || paymentType == "3" {
        } else if paymentType == "4" {
            self.payUsingPaypal(orderReturn: orderReturn)
        } else {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Success!", actionButtonTitle: "OK", completion: {
                _ = BookingDetailController.push(on: self.navigationController!, bookingId: orderReturn.summary!.id!, type: "1", isComeFromOrder: true)
            })
        }
    }
    fileprivate func payUsingPaypal(orderReturn: OrderReturn) {
        var amount = NSDecimalNumber(value: orderReturn.paypalCurrency!.amount)
        amount = amount.round(2)
        let paypalPayment = PayPalPayment(amount: amount, currencyCode: orderReturn.paypalCurrency!.currency!, shortDescription: "\(orderReturn.summary!.order!.orderId!)", intent: PayPalPaymentIntent.sale)
        paypalPayment.invoiceNumber = "\(orderReturn.summary!.order!.orderId!)"
        let paymentController = PayPalPaymentViewController(payment: paypalPayment, configuration: payPalConfig, delegate: self)
        self.present(paymentController!, animated: true, completion: nil)
    }
    
    fileprivate func payUsingMidtrans(orderId: String,
                                      value: Double,
                                      billingAddress: NAddress,
                                      shippingAddress: NAddress,
                                      merchants: [Merchant],
                                      additionals: [Additional]?,
                                      voucher: Voucher?,
                                      veritransToken: String,
                                      paymentType: Int) {
        MidtransNetworkLogger.shared().startLogging()
        let transactionDetails = MidtransTransactionDetails.init(orderID: orderId, andGrossAmount: NSNumber(value: value))
    
        let customerDetails = MidtransCustomerDetails.init(firstName: billingAddress.fullname!, lastName: "", email: billingAddress.emailAddress!, phone: billingAddress.phoneNumber, shippingAddress: nil, billingAddress: nil)
        let preferences = UserDefaults.standard
        preferences.set(billingAddress.emailAddress!, forKey: "email_address")
        preferences.set(billingAddress.phoneNumber!, forKey: "phone_number")
        
        var itemDetails: [MidtransItemDetail] = []
        for merchant in merchants {
            if let products = merchant.products, !products.isEmpty {
                for product in products {
                    let itemDetail = MidtransItemDetail(itemID: product.productCartId!, name: product.productName!, price: NSNumber(value: product.specialPrice/Double(product.qty)), quantity: NSNumber(value: product.qty))
                    itemDetails.append(itemDetail!)
                }
                
            }
        }
        var itemID = -1

        if let additionals = additionals, !additionals.isEmpty {
            for additional in additionals {
                itemDetails.append(MidtransItemDetail(itemID: String(itemID), name: additional.title!, price: NSNumber(value: additional.value!), quantity: 1))
                itemID -= 1
            }
        }
        if let voucher = voucher {
            itemDetails.append(MidtransItemDetail(itemID: String(itemID), name: "Voucher(\(voucher.code!))", price: NSNumber(value: -voucher.value), quantity: 1))
        }
        let paymentFeature = (paymentType==2 ? MidtransPaymentFeature.MidtransPaymentFeatureCreditCard : MidtransPaymentFeature.MidtransPaymentFeatureBankTransfer)
        let response = MidtransTransactionTokenResponse()

        response.customerDetails = customerDetails!
        response.itemDetails = itemDetails
        response.tokenId = veritransToken
        response.transactionDetails = transactionDetails

        let vc = MidtransUIPaymentViewController(token: response, andPaymentFeature: paymentFeature)
        vc?.paymentDelegate = self
        self.present(vc!, animated: true, completion: nil)
    }

    
    fileprivate func tryChangePayment(paymentType: Int) {
        self.priceLabel.text = "Calculating"
        self.payNowButton.isEnabled = false
        self.payNowButton.backgroundColor = UIColor.darkGray
        var id: String = ""
        if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let order = summary.order {
            id = order.orderId!
        } else if let cartReturn = self.cartReturn {
            id = cartReturn.cartToken!
        }
        
        self.payNowButton.backgroundColor = UIColor.darkGray
        self.payNowButton.isEnabled = false
        self.priceLabel.text = "Calculating..."
        var voucherCode: String? = nil
        if let cartReturn = self.cartReturn, let cart = cartReturn.cart, let voucher = cart.voucher, let code = voucher.code {
            voucherCode = code
        }
        
        NHTTPHelper.changePaymentMethod(cartToken: id, paymentType: paymentType, voucherCode: voucherCode, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryChangePayment(paymentType: paymentType)
                    })
                }
                return
            }
            self.payNowButton.backgroundColor = UIColor.blueActive
            self.payNowButton.isEnabled = true
            if let data = response.data {
                self.cartReturn = data
                self.isLoadAdditionalFee = false
                self.calculateGrandTotal()
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
                    if self.shippingAddress != nil {
                        self.priceLabel.text = "Calculating"
                        self.payNowButton.isEnabled = false
                        self.payNowButton.backgroundColor = UIColor.darkGray
                        self.pickedCourierTypes = []
                        self.pickedCouriers = []
                    }
                    self.tableView.reloadRows(at: [IndexPath(row: 0, col: 1), IndexPath(row: 1, col: 1)], with: .automatic)
                    self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
                    self.tableView.reloadSections(IndexSet(integer: 4), with: .automatic)
                })
            }
            cell.row = indexPath.row
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourierCell", for: indexPath) as! CourierCell
            var courierType: CourierType? = !self.pickedCourierTypes.isEmpty ? self.pickedCourierTypes[indexPath.row] : nil
            let courier: Courier? = !self.pickedCourierTypes.isEmpty ? self.pickedCouriers[indexPath.row] : nil
            let merchant = self.cartReturn!.cart!.merchants![indexPath.row]
            cell.initData(merchant: merchant, courier: courier, courierType: courierType)
            cell.onChangeCourier = {row in
                if self.shippingAddress == nil {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Please pick shipping address!", completion: {})
                    return
                }
                var courier: Courier? = nil
                if !self.pickedCouriers.isEmpty && row <= self.pickedCouriers.count - 1 && !self.pickedCourierTypes.isEmpty && row <= self.pickedCourierTypes.count - 1 {
                    courier = self.pickedCouriers[row]
                    courierType = self.pickedCourierTypes[row]
                }
                let _ = ChangeCourierController.push(on: self.navigationController!, row: row, originAddressId: merchant.districtId!, destinationAddressId: self.shippingAddress!.district!.id!, weight: Int(ceil(merchant.totalWeight)), pickedCourier: courier, pickedCourierType: courierType, completion: {index, cour, courType in
                    self.priceLabel.text = "Calculating"
                    self.payNowButton.isEnabled = false
                    self.payNowButton.backgroundColor = UIColor.darkGray
                    if !self.pickedCouriers.isEmpty && row <= self.pickedCouriers.count - 1 && !self.pickedCourierTypes.isEmpty && row <= self.pickedCourierTypes.count - 1 {
                        self.pickedCouriers[row] = cour
                        self.pickedCourierTypes[row] = courType
                    } else {
                        self.pickedCouriers.append(cour)
                        self.pickedCourierTypes.append(courType)
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.calculateGrandTotal()
                })
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
            cell.paymentType = self.paymentMethodType
            cell.onChangePaymentType = {paymentType in
                self.paymentMethodType = paymentType
                self.isLoadAdditionalFee = true
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 4),  IndexPath(item: 0, section: 5)], with: .automatic)
                self.tryChangePayment(paymentType: self.paymentMethodType)
            }
            cell.initPayment(paymentType: self.paymentMethodType)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutSummaryCell", for: indexPath) as! CheckoutSummaryCell
            if let cartReturn = self.cartReturn, let cart = cartReturn.cart {
                cell.initData(merchants: cart.merchants!, voucher: cart.voucher, couriers: self.pickedCouriers, courierTypes: self.pickedCourierTypes, additionals: cartReturn.additionals)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CheckoutController2: PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, MidtransUIPaymentViewControllerDelegate {
    func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
        viewController.dismiss(animated: true, completion: {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Failed", actionButtonTitle: "OK", completion: {
                
            })
        })
    }
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, saveCardFailed error: Error!) {
        
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
        viewController.dismiss(animated: true, completion: {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Success!", actionButtonTitle: "OK", completion: {
                let transactionResult = NTransactionResult(transactionData: result, fraudStatus: "pending")
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NHTTPHelper.httpVeritransNotification(parameters: transactionResult.serialized(), complete: {response in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    _ = BookingDetailController.push(on: self.navigationController!, bookingId: self.orderReturn!.summary!.id!, type: "1", isComeFromOrder: true)
                })
            })
        })
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
        viewController.dismiss(animated: true, completion: {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Success!", actionButtonTitle: "OK", completion: {
                let transactionResult = NTransactionResult(transactionData: result, fraudStatus: "accept")
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NHTTPHelper.httpVeritransNotification(parameters: transactionResult.serialized(), complete: {response in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    _ = BookingDetailController.push(on: self.navigationController!, bookingId: self.orderReturn!.summary!.id!, type: "1", isComeFromOrder: true)
                })
            })
        })
    }
    
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, save result: MidtransMaskedCreditCard!) {
        
    }

    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
        
    }
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: {})
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true, completion: {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Success!", actionButtonTitle: "OK", completion: {
                _ = BookingDetailController.push(on: self.navigationController!, bookingId: self.orderReturn!.summary!.id!, type: "1", isComeFromOrder: true)
            })
        })
    }
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable : Any]) {
        
    }
    
    

}
