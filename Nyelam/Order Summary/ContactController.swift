//
//  ContactController.swift
//  Nyelam
//
//  Created by Bobi on 5/3/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MMNumberKeyboard
import ActionSheetPicker_3_0
import MBProgressHUD
import UINavigationControllerWithCompletionBlock

class ContactController: BaseViewController, MMNumberKeyboardDelegate {
    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    var phoneRegionCode: String = "ID"

    var numberKeyboard: MMNumberKeyboard?
    var bookingContact: BookingContact?
    var pickedCountryCode: NCountryCode?
    var countryCodes: [NCountryCode]? = NCountryCode.getCountryCodes()
    var completion: (UINavigationController, BookingContact)->() = {navigation, contact in }
    
    static func push(on controller: UINavigationController, contact: BookingContact, completion: @escaping (UINavigationController, BookingContact)-> ()) -> ContactController {
        let vc: ContactController = ContactController(nibName: "ContactController", bundle: nil)
        vc.bookingContact = contact
        vc.completion = completion
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        self.title = "Contact"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func initView() {
        self.fullnameTextField.delegate = self
        self.emailAddressTextField.delegate = self
        self.numberKeyboard = MMNumberKeyboard(frame: CGRect.zero)
        self.numberKeyboard!.returnKeyTitle = "Done"
        self.numberKeyboard!.allowsDecimalPoint = false
        self.numberKeyboard!.delegate = self
        self.phoneNumberTextField.inputView = self.numberKeyboard!
    }
    fileprivate func initData() {
        if let contact = self.bookingContact {
            self.fullnameTextField.text = contact.name
            self.emailAddressTextField.text = contact.email
            if let countryCode = contact.countryCode, let number = countryCode.countryNumber {
                self.pickedCountryCode = countryCode
                self.countryCodeLabel.text = ("+\(number)")
                self.phoneNumberTextField.text = contact.phoneNumber
            } else {
                self.pickedCountryCode =  NCountryCode.getCountryCode(by: self.phoneRegionCode)
                self.countryCodeLabel.text = ("+\(self.pickedCountryCode!.countryNumber!)")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullnameTextField {
            self.emailAddressTextField.becomeFirstResponder()
        } else if textField == self.emailAddressTextField {
            self.phoneNumberTextField.becomeFirstResponder()
        }
        return true
    }
    
    func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool {
        self.phoneNumberTextField.resignFirstResponder()
        self.submitButtonAction(self.phoneNumberTextField)
        return true
    }
    
    
    @IBAction func countryCodeButtonAction(_ sender: Any) {
        if let countryCodes = self.countryCodes, !countryCodes.isEmpty {
            var c: [String] = []
            for countryCode in countryCodes {
                if let number = countryCode.countryNumber, let countryName = countryCode.countryName {
                    c.append("+\(number) \(countryName)")
                }
            }
            let actionSheet = ActionSheetStringPicker.init(title: "Country Code", rows: c, initialSelection: NCountryCode.getPosition(by: self.phoneRegionCode), doneBlock: {picker, index, value in
                self.pickedCountryCode = countryCodes[index]
                self.phoneRegionCode = countryCodes[index].countryCode!
                self.countryCodeLabel.text = ("+ \(countryCodes[index].countryNumber!)")
            }, cancel: {_ in return
                
            }, origin: sender)
            
            actionSheet!.show()
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if let error = self.validateError(name: self.fullnameTextField.text!, phoneNumber: self.phoneNumberTextField.text!, emailAddress: self.emailAddressTextField.text!) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        self.bookingContact!.name = self.fullnameTextField.text
        self.bookingContact!.email = self.emailAddressTextField.text
        self.bookingContact!.countryCode = self.pickedCountryCode
        self.bookingContact!.phoneNumber = self.phoneNumberTextField.text

        if let navigation = self.navigationController {
            self.completion(navigation, self.bookingContact!)
        }
        
    }
    
    func validateError(name: String, phoneNumber: String, emailAddress: String) -> String? {
        if name.isEmpty {
            return "Fullname cannot be empty"
        } else if phoneNumber.isEmpty {
            return "Phone number cannot be empty"
        } else if emailAddress.isEmpty {
            return "Email address cannot be empty"
        } else if !emailAddress.isEmailRegex {
            return "Please type valid email address"
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
