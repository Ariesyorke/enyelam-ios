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

class ContactController: BaseViewController, MMNumberKeyboardDelegate {
    var contact: Contact?
    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    var numberKeyboard: MMNumberKeyboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
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
