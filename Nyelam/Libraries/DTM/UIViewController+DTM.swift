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
    
    // MARK: Keyboard Event Callback
    public func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        
    }
    
    public func keyboardWillHide(animationDuration: TimeInterval) {
        
    }
}
