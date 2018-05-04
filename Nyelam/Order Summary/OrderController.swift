//
//  OrderController.swift
//  Nyelam
//
//  Created by Bobi on 5/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import DLRadioButton

class OrderController: BaseViewController {
    private let sections = ["Your Booking", "Contact Details", "Participant Details","Payment Options", "Booking Summary"]
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    static func push(on controller: UINavigationController, diveService: NDiveService, cartReturn: CartReturn, contact: Contact, participants: [Participant], selectedDate: Date) -> OrderController {
        let vc: OrderController = OrderController(nibName: "OrderController", bundle: nil)
        vc.diveService = diveService
        vc.cartReturn = cartReturn
        vc.contact = contact
        vc.participants = participants
        vc.selectedDate = selectedDate
        controller.pushViewController(vc, animated: true)
        return vc
    }

    fileprivate var summary: NSummary?
    fileprivate var diveService: NDiveService?
    fileprivate var cartReturn: CartReturn?
    fileprivate var contact: Contact?
    fileprivate var participants: [Participant]?
    fileprivate var isLoadAdditionalFee: Bool = false
    fileprivate var paymentMethodType: Int = 0
    fileprivate var selectedDate: Date?
    fileprivate var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tableView.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellReuseIdentifier: "ParticipantCell")
        self.tableView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        self.tableView.register(UINib(nibName: "BookingDetailCell", bundle: nil), forCellReuseIdentifier: "BookingDetailCell")
        self.tableView.register(UINib(nibName: "BookingSummaryCell", bundle: nil), forCellReuseIdentifier: "BookingSummaryCell")
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payButtonAction(_ sender: Any) {
        
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
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle = NBookingTitleSection(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        sectionTitle.subtitleLabel.isHidden = true
        sectionTitle.titleLabel.text = self.sections[section]
        return sectionTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell", for: indexPath) as! BookingDetailCell
            cell.initData(diveService: diveService!, selectedDate: self.selectedDate!)
            return cell
        } else if indexPath.section == 1 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            cell.initData(contact: self.contact!)
            return cell
        } else if indexPath.section == 2 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
            let participant = participants![row]
            cell.initData(participant: participant)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
            cell.paymentType = self.paymentMethodType
            cell.onChangePaymentType = {paymentType in
                self.paymentMethodType = paymentType
            }
            cell.initPayment(paymentType: self.paymentMethodType)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingSummaryCell", for: indexPath) as! BookingSummaryCell
            let diver = self.participants!.count
            cell.initData(note: self.note, cart: cartReturn!.cart!, selectedDiver: diver, servicePrice: self.diveService!.specialPrice, additionals: self.cartReturn!.additionals)
            return cell
        }
        return UITableViewCell()
    }
}

class ContactCell: NTableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    var indexPath: IndexPath?

    var onChangeContact: (IndexPath) -> () = {indexPath in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func changeButtonAction(_ sender: Any) {
        self.onChangeContact(indexPath!)
    }
    
    func initData(contact: Contact) {
        if let name = contact.name {
            self.fullNameLabel.text = name
        } else {
            self.fullNameLabel.text = "Fullname"
        }
        self.phoneNumberLabel.text = contact.phoneNumber
        self.emailAddressLabel.text = contact.emailAddress
    }
    
}


class ParticipantCell: NTableViewCell {
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var onChangePartcipant: (IndexPath) -> () = {indexPath in }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func changeButtonAction(_ sender: Any) {
        self.onChangePartcipant(indexPath!)
    }
    
    func initData(participant: Participant) {
        if let name = participant.name {
            self.fullnameLabel.text = name
        }
        if let email = participant.email {
            self.emailAddressLabel.text = email
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
        if sender.tag == 0 {
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
        self.paymentType = 0
        if paymentType == 0 {
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


