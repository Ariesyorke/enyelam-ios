//
//  ChangePasswordViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var currentPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeButtonAction(_ sender: Any) {
        let currentPassword = self.currentPasswordTextField.text!
        let newPassword = self.newPasswordTextField.text!
        let confirmPassword = self.confirmPasswordTextField.text!
        if let error = validateForm(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        self.tryChangePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
    }
    
    internal func validateForm(currentPassword: String, newPassword: String, confirmPassword: String) -> String? {
        if currentPassword.isEmpty {
            return "Current password cannot be empty"
        } else if newPassword.isEmpty {
            return "New password cannot be empty"
        } else if confirmPassword.isEmpty {
            return "Confirm password cannot be empty"
        } else if newPassword != confirmPassword {
            return "Confirm password doesn't match"
        }
        return nil
    }
    
    internal func tryChangePassword(currentPassword: String, newPassword: String, confirmPassword: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpChangePassword(currentPassword: currentPassword, newPasword: newPassword, confirmNewPassword: confirmPassword, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryChangePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
                    })
                } else {
                    let err = error as! StatusFailedError
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {_ in
                        
                    })
                }
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Change password success!", actionButtonTitle: "OK", completion: {
                self.backButtonAction(UIBarButtonItem())
            })
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
