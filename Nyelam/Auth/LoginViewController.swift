//
//  LoginViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import MBProgressHUD

class LoginViewController: BaseViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        self.emailAddressTextField.delegate = self
        self.passwordTextField.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            let vc = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        let emailAddress = self.emailAddressTextField.text!
        let password = self.passwordTextField.text!
        if let error = self.validateForm(emailAddress: emailAddress, password: password) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {
                //TODO NOTHING
            })
            return
        }
        self.tryLoginUsingEmail(emailAddress: emailAddress, password: password)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            let vc = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
            navigation.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.tryLoginUsingSocmed(accessToken: signIn.currentUser.authentication.accessToken, emailAddress: signIn.currentUser.profile.email, type: "google", id: signIn.currentUser.userID)
        GIDSignIn.sharedInstance().signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    internal func tryLoginUsingEmail(emailAddress: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpLogin(email: emailAddress, password: password, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.handleAuthResponse(response: response, completion: {error in
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoginUsingEmail(emailAddress: emailAddress, password: password)
                    })
                }
            })
        })
    }
    internal func tryLoginUsingSocmed(accessToken: String, emailAddress: String, type: String, id: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpLoginSocmed(email: emailAddress, type: type, id: id, accessToken: accessToken, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.handleAuthResponse(response: response, completion: {error in
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoginUsingSocmed(accessToken: accessToken, emailAddress: emailAddress, type: type, id: id)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    
                }
            })
        })
    }
    
    internal func handleAuthResponse(response: NHTTPResponse<NAuthReturn>, completion: @escaping (BaseError)->()) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let error = response.error {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                completion(error)
            })
            return
        }
        if let data = response.data {
            
        }

    }
    
    internal func validateForm(emailAddress: String, password: String )-> String? {
        if emailAddress.isEmpty {
            return "Email address cannot be empty"
        } else if !emailAddress.isEmailRegex {
            return "Please input valid email address"
        } else if password.isEmpty {
            return "Password cannot be empty"
        }
        return nil
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailAddressTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
            self.loginButtonAction(textField)
        }
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
