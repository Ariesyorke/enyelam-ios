//
//  AddAddressViewController.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

class AddAddressViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var provinceTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var postalCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: KMPlaceholderTextView!
    @IBOutlet weak var districtTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullnameTextField.delegate = self
        self.provinceTextField.delegate = self
        self.cityTextField.delegate = self
        self.postalCodeTextField.delegate = self
        self.noteTextField.delegate = self
        self.addressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.districtTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
