//
//  ParticipantController.swift
//  Nyelam
//
//  Created by Bobi on 5/3/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import UINavigationControllerWithCompletionBlock

class ParticipantController: BaseViewController {
    static func push(on controller: UINavigationController, participant: Participant, completion: @escaping (UINavigationController, Participant)-> ()) -> ParticipantController {
        let vc: ParticipantController = ParticipantController(nibName: "ParticipantController", bundle: nil)
        vc.participant = participant
        vc.completion = completion
        controller.pushViewController(vc, animated: true)
        return vc
    }

    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    var participant: Participant?
    
    var completion: (UINavigationController, Participant)->() = {navigation, participant in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        var fullname = fullnameTextField.text!
        var emailAddress = emailTextField.text!
        if let error = self.validateError(name: fullname, emailAddress: emailAddress) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        self.participant!.name = fullname
        self.participant!.email = emailAddress
        if let navigation = self.navigationController {
            self.completion(navigation, self.participant!)
        }
    }
    
    fileprivate func initView() {
        self.fullnameTextField.delegate = self
        self.emailTextField.delegate = self
        self.title = "Participant"
    }
    
    fileprivate func initData() {
        if let participant = self.participant {
            self.fullnameTextField.text = participant.name
            self.emailTextField.text = participant.email
        }
    }
    
    fileprivate func validateError(name: String, emailAddress: String) -> String? {
        if name.isEmpty {
            return "Fullname cannot be empty"
        } else if emailAddress.isEmpty {
            return "Email address cannot be empty"
        } else if !emailAddress.isEmailRegex {
            return "Please type valid email address"
        }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullnameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            textField.resignFirstResponder()
            self.submitButtonAction(textField)
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
