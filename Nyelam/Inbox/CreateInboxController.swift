//
//  CreateInboxController.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MultilineTextField
import ActionSheetPicker_3_0
import MBProgressHUD
import UIScrollView_InfiniteScroll
import UINavigationControllerWithCompletionBlock

class CreateInboxController: BaseViewController {
    var reportTypes = ["General", "Issue App", "Payment"]
    var fromHome: Bool = false
    var subject: String = ""
    
    @IBOutlet weak var reportTypeLabel: UILabel!
    @IBOutlet weak var multilineTextField: MultilineTextField!
    @IBOutlet weak var reportTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageContainerVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var messageTextField: MultilineTextField!
    @IBOutlet weak var attachImageView: UIImageView!
    
    var index: Int = 0
    var inboxType: Int = -1
    var refId: String?
    var attachment: Data?
    var completion: ()->() = {}
    let picker = UIImagePickerController()
    
    static func push(on controller: UINavigationController, inboxType: Int, fromHome: Bool, subject: String, completion: @escaping ()->()) -> CreateInboxController {
        let vc: CreateInboxController = CreateInboxController(nibName: "CreateInboxController", bundle: nil)
        vc.inboxType = inboxType
        vc.fromHome = fromHome
        vc.subject = subject
        vc.completion = completion
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, inboxType: Int, fromHome: Bool, refId: String?, subject: String, completion: @escaping ()->()) -> CreateInboxController {
        let vc: CreateInboxController = CreateInboxController(nibName: "CreateInboxController", bundle: nil)
        vc.inboxType = inboxType
        vc.fromHome = fromHome
        vc.refId = refId
        vc.subject = subject
        vc.completion = completion
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Inbox"
        if self.inboxType < 3 {
            self.downArrow.isHidden = true
            self.reportTypeHeightConstraint.constant = 0
            self.messageContainerVerticalSpacing.constant = 0
        }
    }
    
    override func backButtonAction(_ sender: UIBarButtonItem) {
        if let navigation = self.navigationController as? BaseNavigationController {
            if self.fromHome {
                self.moveSafeAreaInsets()
                navigation.setNavigationBarHidden(true, animated: true)
                navigation.navigationBar.barTintColor = UIColor.primary
            }
            navigation.popViewController(animated: true, withCompletionBlock: completion)
        }
//        super.backButtonAction(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func reportButtonAction(_ sender: Any) {
        let actionSheet = ActionSheetStringPicker.init(title: "Report Type", rows: reportTypes, initialSelection: self.index, doneBlock: {picker, index, value in
            self.index = index
            self.inboxType = index + 3
            self.reportTypeLabel.text = self.reportTypes[index]
            self.subject = self.reportTypes[index]
            
        }, cancel: {_ in return
        }, origin: sender)
        actionSheet!.show()
    }
    
    @IBAction func attachButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        UIAlertController.showAlertWithMultipleChoices(title: "Add Attachment", message: nil, viewController: self, buttons: [
            UIAlertAction(title: "Gallery", style: .default, handler: {alert in
                self.picker.sourceType = .photoLibrary
                self.picker.delegate = self
                self.picker.allowsEditing = false
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.picker, animated: true, completion: nil)
            }),
            UIAlertAction(title: "Take Photo", style: .default, handler: {alert in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.picker.sourceType = UIImagePickerControllerSourceType.camera
                    self.picker.cameraCaptureMode = .photo
                    self.picker.delegate = self
                    self.picker.allowsEditing = false
                    self.picker.modalPresentationStyle = .fullScreen
                    self.present(self.picker,animated: true,completion: nil)
                } else {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Sorry this device has no camera", completion: {})
                }
            }),
            UIAlertAction(title: "Cancel", style: .default, handler: {alert in
                
            })
        ])
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let message = messageTextField.text
        if let error = self.validateError(message: message) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        self.trySendMessage(subject: self.subject, message: message!, attachment: self.attachment, inboxType: self.inboxType, refId: self.refId)
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.navigationItem.rightBarButtonItem = nil
            self.scrollViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        self.view.layoutIfNeeded()
        let item = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonAction(_:)))
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "FiraSans-SemiBold", size: 15)!,
                                     NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = item

        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollViewBottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func onDoneButtonAction(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    fileprivate func validateError(message: String?) -> String? {
        if message == nil || message!.isEmpty {
            return "You must at write message!"
        }
        return nil
    }
    
    fileprivate func trySendMessage(subject: String, message: String, attachment: Data?, inboxType: Int, refId: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpPostInbox(subjectName: subject, subjectDetail: message, attachment: attachment, inboxType: inboxType, refId: refId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.trySendMessage(subject: subject, message: message, attachment: attachment, inboxType: inboxType, refId: refId)
                        })
                    }
                })
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Message successfully created!", actionButtonTitle: "OK", completion: {
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

extension CreateInboxController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: {
            if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let resizedImage = chosenImage.resized(toWidth: 400)
                self.attachment = UIImageJPEGRepresentation(resizedImage!, 0.75)
                self.attachButton.setTitle("Attached", for: .normal)
                self.attachImageView.image = resizedImage
            }
        })
    }
}

