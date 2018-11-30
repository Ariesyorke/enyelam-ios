//
//  OrderController.swift
//  Nyelam
//
//  Created by Bobi on 5/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import DLRadioButton
import MidtransKit
import MBProgressHUD
import PopupController
import UINavigationControllerWithCompletionBlock

class OrderController: BaseViewController {
    private let sections = ["Your Booking", "Contact Details", "Participant Details", "Payment Options", "Voucher", "Booking Summary"]
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    var payPalConfig = PayPalConfiguration()
    
    static func push(on controller: UINavigationController, diveService: NDiveService, cartReturn: CartReturn, contact: BookingContact, participants: [Participant], selectedDate: Date) -> OrderController {
        let vc: OrderController = OrderController(nibName: "OrderController", bundle: nil)
        vc.diveService = diveService
        vc.cartReturn = cartReturn
        vc.contact = contact
        vc.participants = participants
        vc.selectedDate = selectedDate
        controller.pushViewController(vc, animated: true)
        return vc
    }

    fileprivate var orderReturn: OrderReturn?
    fileprivate var diveService: NDiveService?
    fileprivate var cartReturn: CartReturn?
    fileprivate var contact: BookingContact?
    fileprivate var participants: [Participant]?
    fileprivate var isLoadAdditionalFee: Bool = false
    fileprivate var paymentMethodType: Int = 1
    fileprivate var selectedDate: Date?
    fileprivate var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: NConstant.paypalEnvironment)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payButtonAction(_ sender: Any) {
        if let error = self.checkDataCompletion(bookingContact: self.contact!, participants: self.participants!) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        
        if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let order = summary.order {
            let orderID = order.orderId!
            self.tryResubmitOrder(orderId: orderID, paymentType: self.paymentMethodType)
        } else if let cartReturn = self.cartReturn {
            let diveEthicAgreementController = DiveEthicAgreementController(nibName: "DiveEthicAgreementController", bundle: nil)
            let size = CGSize(width: (self.navigationController!.view.frame.width * 3.5)/4, height: (self.navigationController!.view.frame.height * 3)/4)
            diveEthicAgreementController.popupSize = size
            let popup = PopupController.create(self.navigationController!).customize(
                [
                    .animation(.fadeIn),
                    .backgroundStyle(.blackFilter(alpha: 0.7)),
                    .dismissWhenTaps(false),
                    .layout(.center)
                ])
            
            _ = popup.show(diveEthicAgreementController)
            
            diveEthicAgreementController.dismissCompletion = {complete in
                popup.dismiss({
                    if complete {
                        var participantsJson: Array<[String: Any]> = []
                        for participant in self.participants! {
                            participantsJson.append(participant.serialized())
                        }
                        var voucherCode: String? = nil
                        if let cartReturn = self.cartReturn, let cart = cartReturn.cart, let voucher = cart.voucher, let code = voucher.code {
                            voucherCode = code
                        }
                        self.trySubmitOrder(cartToken: cartReturn.cartToken!, contactJson: String.JSONStringify(value: self.contact!.serialized()), diverJson: String.JSONStringify(value: participantsJson), paymentMethodType: String(self.paymentMethodType), voucher: voucherCode, note: self.note)
                    }
                })
            }
        }
    }
    
    fileprivate func initView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tableView.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellReuseIdentifier: "ParticipantCell")
        self.tableView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        self.tableView.register(UINib(nibName: "BookingDetailCell", bundle: nil), forCellReuseIdentifier: "BookingDetailCell")
        self.tableView.register(UINib(nibName: "BookingSummaryCell", bundle: nil), forCellReuseIdentifier: "BookingSummaryCell")
        self.tableView.register(UINib(nibName: "VoucherCell", bundle: nil), forCellReuseIdentifier: "VoucherCell")
        self.tableView.reloadData()
        self.priceLabel.text = self.cartReturn!.cart!.total.toCurrencyFormatString(currency: "Rp")
        self.title = "Booking Summary"
        self.payPalConfig.acceptCreditCards = true
    }
    
    fileprivate func tryResubmitOrder(orderId: String, paymentType: Int)  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpResubmitOrder(orderId: orderId, paymentType: paymentType, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryResubmitOrder(orderId: orderId, paymentType: paymentType)
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
                self.handlePaymentMethodType(orderReturn: self.orderReturn!, paymentType: String(paymentType))
            }
        })
    }
    
    fileprivate func trySubmitOrder(cartToken: String, contactJson: String, diverJson: String, paymentMethodType: String, voucher: String?, note: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpOrderSubmit(cartToken: cartToken, contactJson: contactJson, diverJson: diverJson, voucherCode: voucher, paymentMethodType: paymentMethodType, note: note, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.trySubmitOrder(cartToken: cartToken, contactJson: contactJson, diverJson: diverJson, paymentMethodType: paymentMethodType, voucher: voucher, note: note)
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
                self.handlePaymentMethodType(orderReturn: self.orderReturn!, paymentType: paymentMethodType)
            }
        })
    }
    
    fileprivate func handlePaymentMethodType(orderReturn: OrderReturn, paymentType: String) {
        if paymentType == "2" || paymentType == "3" {
            self.payUsingMidtrans(order: orderReturn.summary!.order!, contact: self.contact!, amount: Int(self.cartReturn!.cart!.total), veritransToken: orderReturn.veritransToken!, diveService: self.diveService!, divers: self.participants!.count, paymentType: self.paymentMethodType, additionals: self.cartReturn!.additionals, voucher: self.cartReturn!.cart!.voucher)
        } else if paymentType == "4" {
            self.payUsingPaypal(orderReturn: orderReturn)
        } else {
            UIAlertController.handlePopupMessage(viewController: self, title: "Order Success!", actionButtonTitle: "OK", completion: {
                _ = BookingDetailController.push(on: self.navigationController!, bookingId: orderReturn.summary!.id!, type: "1", isComeFromOrder: true)
            })
        }
    }
    
    fileprivate func checkDataCompletion(bookingContact: BookingContact, participants: [Participant]) -> String? {
        if bookingContact.name == nil || bookingContact.name!.isEmpty {
            return "Contact name cannot be empty"
        } else if bookingContact.email == nil || bookingContact.email!.isEmpty {
            return "Contact email cannot be empty"
        } else if bookingContact.phoneNumber == nil || bookingContact.phoneNumber!.isEmpty {
            return "Contact phone cannot be empty"
        }
        for participant in participants {
            if participant.name == nil || participant.name!.isEmpty {
                return "Participant name cannot be empty"
            } else if participant.email == nil || participant.email!.isEmpty {
                return "Participant email cannot be empty"
            }
        }
        return nil
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

extension OrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.participants != nil ? self.participants!.count : 0
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = NBookingTitleSection(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        sectionTitle.subtitleLabel.isHidden = true
        sectionTitle.titleLabel.text = self.sections[section]
        return sectionTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell", for: indexPath) as! BookingDetailCell
            cell.initData(diveService: self.diveService!, selectedDate: self.selectedDate!)
            return cell
        } else if indexPath.section == 1 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            cell.initData(contact: self.contact!)
            cell.onChangeContact = {
                _ = ContactController.push(on: self.navigationController!, contact: self.contact!, completion: {navigation, contact in
                    navigation.popViewController(animated: true, withCompletionBlock: {
                        DispatchQueue.main.async {
                            self.contact! = contact
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                })
            }
            return cell
        } else if indexPath.section == 2 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
            let participant = participants![row]
            cell.initData(participant: participant)
            cell.onChangeParticipant = {
                _ = ParticipantController.push(on: self.navigationController!, participant: participant,  completion: {navigation, participant in
                    navigation.popViewController(animated: true, withCompletionBlock: {
                        DispatchQueue.main.async {
                            self.participants![row] = participant
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath) as! VoucherCell
            if let _ = orderReturn {
                UIAlertController.handleErrorMessage(viewController: self, error: "You already submitted order you cannot change/edit voucher", completion: {})
            }
            if let cartReturn = self.cartReturn  {
                if let cart = cartReturn.cart, let voucher = cart.voucher {
                    cell.voucherTextField.text = voucher.code
                }
                cell.onVoucherApplied = {code in
                    self.view.endEditing(true)
                    if let code = code, !code.isEmpty {
                        self.tryAddVoucher(voucherCode: code, cartToken: cartReturn.cartToken!)
                    } else {
                        UIAlertController.handleErrorMessage(viewController: self, error: "Voucher code cannot be empty!", completion: {})
                    }
                }
            }
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingSummaryCell", for: indexPath) as! BookingSummaryCell
            let diver = self.participants!.count
            cell.noteTextField.delegate = self
            if self.isLoadAdditionalFee {
                cell.loadAdditionalFee()
            } else {
                cell.initData(note: self.note, cart: cartReturn!.cart!, selectedDiver: diver, servicePrice: self.diveService!.specialPrice, additionals: self.cartReturn!.additionals, equipments: self.cartReturn!.equipments)
            }
            return cell
        }
        return UITableViewCell()
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell", for: indexPath) as! BookingDetailCell
//            cell.initData(diveService: self.diveService!, selectedDate: self.selectedDate!)
//            return cell
//        } else if indexPath.section == 1 {
//            let row = indexPath.row
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
//            cell.initData(contact: self.contact!)
//            cell.onChangeContact = {
//                _ = ContactController.push(on: self.navigationController!, contact: self.contact!, completion: {navigation, contact in
//                    navigation.popViewController(animated: true, withCompletionBlock: {
//                        DispatchQueue.main.async {
//                            self.contact! = contact
//                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                        }
//                    })
//                })
//            }
//            return cell
//        } else if indexPath.section == 2 {
//            let row = indexPath.row
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
//            let participant = participants![row]
//            cell.initData(participant: participant)
//            cell.onChangeParticipant = {
//                _ = ParticipantController.push(on: self.navigationController!, participant: participant,  completion: {navigation, participant in
//                    navigation.popViewController(animated: true, withCompletionBlock: {
//                        DispatchQueue.main.async {
//                            self.participants![row] = participant
//                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                        }
//                    })
//                })
//            }
//            return cell
//        } else if indexPath.section == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
//            cell.paymentType = self.paymentMethodType
//            cell.onChangePaymentType = {paymentType in
//                self.paymentMethodType = paymentType
//                self.isLoadAdditionalFee = true
//                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 4)], with: .automatic)
//                self.tryChangePayment(paymentType: self.paymentMethodType)
//            }
//            cell.initPayment(paymentType: self.paymentMethodType)
//            return cell
//        } else if indexPath.section == 4 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingSummaryCell", for: indexPath) as! BookingSummaryCell
//            let diver = self.participants!.count
//            cell.noteTextField.delegate = self
//            if self.isLoadAdditionalFee {
//                cell.loadAdditionalFee()
//            } else {
//                cell.initData(note: self.note, cart: cartReturn!.cart!, selectedDiver: diver, servicePrice: self.diveService!.specialPrice, additionals: self.cartReturn!.additionals, equipments: self.cartReturn!.equipments)
//            }
//            return cell
//        }
//        return UITableViewCell()
    }
    
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration) {
            self.tableBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
//        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration) {
            self.tableBottomConstraint.constant = keyboardFrame.height - 84
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.note = textField.text!
        return true
    }
    
    fileprivate func tryAddVoucher(voucherCode: String, cartToken: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.payNowButton.backgroundColor = UIColor.darkGray
        self.payNowButton.isEnabled = false
        self.priceLabel.text = "Calculating..."

        NHTTPHelper.httpAddVoucher(cartToken: cartToken, voucherCode: voucherCode, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryAddVoucher(voucherCode: voucherCode, cartToken: cartToken)
                    })
                } else {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        
                    })
                }
                return
            }
            if let data = response.data {
                self.cartReturn!.cart = data
                self.tryChangePayment(paymentType: self.paymentMethodType)
            }
        })
    }
    
    fileprivate func tryChangePayment(paymentType: Int) {
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
                self.priceLabel.text = self.cartReturn!.cart!.total.toCurrencyFormatString(currency: "Rp")
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 5)], with: .automatic)
            }
        })
    }
    
    fileprivate func payUsingMidtrans(order: NOrder, contact: BookingContact, amount: Int, veritransToken: String, diveService: NDiveService, divers: Int, paymentType: Int, additionals: [Additional]?, voucher: Voucher?) {
        MidtransNetworkLogger.shared().startLogging()
        let transactionDetails = MidtransTransactionDetails.init(orderID: order.orderId!, andGrossAmount: NSNumber(value: amount))
        let customerDetails = MidtransCustomerDetails.init(firstName: contact.name!, lastName: "", email: contact.email!, phone: "+\(contact.countryCode!.countryNumber)\(contact.phoneNumber!)", shippingAddress: nil, billingAddress: nil)
        let preferences = UserDefaults.standard
        preferences.set(contact.email!, forKey: "email_address")
        preferences.set("+\(contact.countryCode!.countryNumber!)\(contact.phoneNumber!)", forKey: "phone_number")
        var itemDetails: [MidtransItemDetail] = []
        let itemDetail = MidtransItemDetail(itemID: diveService.id!, name: diveService.name!, price: NSNumber(value: diveService.specialPrice), quantity: NSNumber(value: divers))
        itemDetails.append(itemDetail!)
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
    
    fileprivate func payUsingPaypal(orderReturn: OrderReturn) {
        var amount = NSDecimalNumber(value: orderReturn.paypalCurrency!.amount)
        amount = amount.round(2)
        let paypalPayment = PayPalPayment(amount: amount, currencyCode: orderReturn.paypalCurrency!.currency!, shortDescription: "\(orderReturn.summary!.order!.orderId!)", intent: PayPalPaymentIntent.sale)
        paypalPayment.invoiceNumber = "\(orderReturn.summary!.order!.orderId!)"
       let paymentController = PayPalPaymentViewController(payment: paypalPayment, configuration: payPalConfig, delegate: self)
        self.present(paymentController!, animated: true, completion: nil)
    }
}

class ContactCell: NTableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    var onChangeContact: () -> () = { }
    var isEditable: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func changeButtonAction(_ sender: Any) {
        self.onChangeContact()
    }
    
    func initData(contact: BookingContact) {
        if let name = contact.name {
            if self.isEditable {
                self.fullNameLabel.text =  "\(contact.titleName.rawValue) \(name)"
            } else {
                self.fullNameLabel.text = name
            }
        } else {
            self.fullNameLabel.text = "Fullname"
        }
        
        if let countryCode = contact.countryCode, let countryNumber = countryCode.countryNumber, let phoneNumber = contact.phoneNumber {
            self.phoneNumberLabel.text = "+\(countryNumber)\(phoneNumber)"
        } else {
            self.phoneNumberLabel.text = "Phone Number"
        }
        self.emailAddressLabel.text = contact.email
    }
    func initData(contact: Contact) {
        if let name = contact.name {
            self.fullNameLabel.text = name
        } else {
            self.fullNameLabel.text = "Fullname"
        }
        if let phoneNumber = contact.phoneNumber {
            self.phoneNumberLabel.text = phoneNumber
        } else {
            self.phoneNumberLabel.text = "Phone Number"
        }
        self.emailAddressLabel.text = contact.emailAddress
    }
}

class ParticipantCell: NTableViewCell {
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var changeButton: UIView!
    var isEditable: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var onChangeParticipant: () -> () = { }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func changeButtonAction(_ sender: Any) {
        self.onChangeParticipant()
    }
    
    func initData(participant: Participant) {
        self.changeLabel.text = "Change"
        if let name = participant.name {
            if self.isEditable {
                self.fullnameLabel.text = "\(participant.titleName.rawValue) \(name)"
            } else {
                self.fullnameLabel.text = name
            }
        } else {
            self.changeLabel.text = "Fill In"
        }
        if let email = participant.email {
            self.emailAddressLabel.text = email
        } else {
            self.changeLabel.text = "Fill In"
        }
    }
}

class PaymentMethodCell: NTableViewCell {
    @IBOutlet weak var paymentButton: DLRadioButton!
    var paymentType: Int = 0
    var onChangePaymentType: (Int)->() = {paymentType in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func changePaymentButtonAction(_ sender: UIControl) {
        if sender.tag == 1 {
            self.paymentButton.isSelected = true
            for button in self.paymentButton.otherButtons {
                button.isSelected = false
            }
        } else {
            self.paymentButton.isSelected = false
            for button in self.paymentButton.otherButtons {
                if button.tag == sender.tag {
                    button.isSelected = true
                    break
                }
            }
        }
        self.onChangePaymentType(sender.tag)
    }
    
    func initPayment(paymentType: Int) {
        self.paymentType = paymentType
        if paymentType == 1 {
            self.paymentButton.isSelected = true
        } else {
            for button in self.paymentButton.otherButtons {
                if button.tag == paymentType {
                    button.isSelected = true
                    break
                }
            }
        }
    }
}

extension OrderController: MidtransUIPaymentViewControllerDelegate, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
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
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
        
    }
    
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

}


