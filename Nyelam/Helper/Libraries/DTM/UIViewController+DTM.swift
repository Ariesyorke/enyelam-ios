//
//  UIViewController+DTM.swift
//  Metro TV News
//
//  Created by Ramdhany Dwi Nugroho on 10/28/16.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    public func dtmViewDidLoad() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(internalKeyboardWillShow), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(internalKeyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func internalKeyboardWillShow(notification: NSNotification) {
        let info: [String: AnyObject] = (notification.userInfo! as? [String: AnyObject])!
        let kbFrame: NSValue = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)!
        let animationDuration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!.doubleValue
        self.keyboardWillShow(keyboardFrame: kbFrame.cgRectValue, animationDuration: animationDuration)
    }
    
    @objc func internalKeyboardWillHide(notification: NSNotification) {
        let info: [String: AnyObject] = (notification.userInfo! as? [String: AnyObject])!
        let animationDuration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!.doubleValue
        self.keyboardWillHide(animationDuration: animationDuration)
    }
    
    @objc func presentAlert(message: String, completion: (() -> Void)?, yesHandler: (() -> Void)?, noHandler: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if yesHandler == nil && noHandler == nil {
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                action in
            }))
        }
        if yesHandler != nil {
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                action in
                yesHandler!()
            }))
        }
        if noHandler != nil {
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
                action in
                noHandler!()
            }))
        }
        
        self.present(alert, animated: true, completion: completion)
    }
    
    @objc func presentAlert(message: String, completion: (() -> Void)?, okHandler: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            action in
            if okHandler != nil {
                okHandler!()
            }
        }))
        
        self.present(alert, animated: true, completion: completion)
    }
    
    @objc func presentAlert(message: String) {
        presentAlert(message: message, completion: nil, yesHandler: nil, noHandler: nil)
    }
    
    // MARK: Keyboard Event Callback
    @objc func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        
    }
    
    @objc func keyboardWillHide(animationDuration: TimeInterval) {
        
    }
}
