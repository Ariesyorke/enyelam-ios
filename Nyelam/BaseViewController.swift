//
//  BaseViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class BaseViewController: UIViewController, UITextFieldDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dtmViewDidLoad()
    }
    
    func handleAuthResponse(response: NHTTPResponse<NAuthReturn>, errorCompletion: @escaping (BaseError)->(), successCompletion: @escaping(NAuthReturn)->()) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let error = response.error {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                errorCompletion(error)
            })
            return
        }
        if let data = response.data {
            successCompletion(data)
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            if self.navigationItem.rightBarButtonItem == nil {
                let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction(_:)))
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }


}
