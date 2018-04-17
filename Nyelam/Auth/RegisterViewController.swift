//
//  RegisterViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0
import MBProgressHUD
import MMNumberKeyboard

class RegisterViewController: BaseViewController, MMNumberKeyboardDelegate {
    @IBOutlet weak var emailAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var numberKeyboard: MMNumberKeyboard?
    
    var regionCode: String = "ID"
    var countryCodes: [NCountryCode]? = NCountryCode.getCountryCodes()
    var pickedCountryCode: NCountryCode?
    var fullName: String?
    var accessToken: String?
    var type: String?
    var pictureUrl: String?
    var socmedId: String?
    var gender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func countryCodeButtonAction(_ sender: Any) {
        if let countryCodes = self.countryCodes, !countryCodes.isEmpty {
            var c: [String] = []
            for countryCode in countryCodes {
                c.append("+\(countryCode.countryNumber!) \(countryCode.countryName!)")
            }
            let actionSheet = ActionSheetStringPicker.init(title: "Country Code", rows: c, initialSelection: NCountryCode.getPosition(by: regionCode), doneBlock: {picker, index, value in
                self.pickedCountryCode = countryCodes[index]
                self.regionCode = countryCodes[index].countryCode!
                self.countryCodeLabel.text = ("+ \(countryCodes[index].countryNumber!)")
            }, cancel: {_ in return
                
            }, origin: sender)
            
            actionSheet!.show()
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        var emailAddress = self.emailAddressTextField.text!
        var phoneNumber = self.phoneNumberTextField.text!
        var password = self.passwordTextField.text!
        var confirmPassword = self.confirmPasswordTextField.text!
        if let error = validateForm(emailAddress: emailAddress, phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {
            })
            return
        }
        self.tryRegister(fullname: self.fullName, email: emailAddress, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, countryCodeId: self.pickedCountryCode!.countryCode!, gender: self.gender, socmedType: self.type, socmedId: self.socmedId, socmedAccessToken: self.accessToken, picture: self.pictureUrl)
    }
    internal func tryRegister(fullname: String?, email: String, password: String, confirmPassword: String, phoneNumber: String, countryCodeId: String, gender: String?, socmedType: String?, socmedId: String?, socmedAccessToken: String?, picture: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpRegister(fullname: fullName, email: email, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, countryCodeId: countryCodeId, gender: gender, socmedType: socmedType, socmedId: socmedId, socmedAccessToken: socmedAccessToken, picture: picture, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.handleAuthResponse(response: response, errorCompletion: {error in
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryRegister(fullname: fullname, email: email, password: password, confirmPassword: confirmPassword, phoneNumber: phoneNumber, countryCodeId: countryCodeId, gender: gender, socmedType: socmedType, socmedId: socmedId, socmedAccessToken: socmedAccessToken, picture: picture)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        
                    })
                }
            },successCompletion: {authReturn in
                if let navigation = self.navigationController as? AuthNavigationController {
                    navigation.authentificationSuccess()
                }
            })
        })

    }
    internal func validateForm(emailAddress: String, phoneNumber: String, password: String, confirmPassword: String) -> String? {
        if emailAddress.isEmpty {
            return "Email address cannot be empty"
        } else if !emailAddress.isEmailRegex {
            return "Please input valid email address"
        } else if phoneNumber.isEmpty {
            return "Phone number cannot be empty"
        } else if password.isEmpty {
            return "Password cannot be empty"
        } else if confirmPassword.isEmpty {
            return "Confirm password cannot be empty"
        } else if password != confirmPassword {
            return "Confirm password doesn't match with password"
        }
        return nil
    }
    
    internal func initView() {
        self.numberKeyboard = MMNumberKeyboard(frame: CGRect.zero)
        self.numberKeyboard!.returnKeyTitle = "Next"
        self.numberKeyboard!.allowsDecimalPoint = false
        self.numberKeyboard!.delegate = self
        self.pickedCountryCode = NCountryCode.getCountryCode(by: regionCode)
        self.title = "e-Nyelam"
        self.phoneNumberTextField.inputView = self.numberKeyboard
        self.emailAddressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailAddressTextField {
            self.phoneNumberTextField.becomeFirstResponder()
        } else if textField == self.phoneNumberTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if textField == self.confirmPasswordTextField {
            textField.resignFirstResponder()
            self.registerButtonAction(textField)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool {
        self.passwordTextField.becomeFirstResponder()
        return true
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
