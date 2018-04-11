//
//  ForgotPasswordViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.emailAddressTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        let emailAddress = self.emailAddressTextField.text!
        if let error = self.validateEmail(emailAddress: emailAddress) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {
                //TODO NOTHING
            })
            return
        }
        NHTTPHelper.httpForgotPassword(email: emailAddress, complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                })
                return
            }
            if let data = response.data {
                if data {
                    UIAlertController.handlePopupMessage(viewController: self, title: "Please check your email", actionButtonTitle: "OK", completion: {})
                }
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.resetButtonAction(textField)
        return true
    }
    
    internal func validateEmail(emailAddress: String) -> String? {
        if emailAddress.isEmpty {
            return "Email address cannot be empty"
        } else if !emailAddress.isEmailRegex {
            return "Please input valid email address"
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
