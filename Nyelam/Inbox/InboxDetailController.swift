//
//  InboxDetailController.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD
import UIScrollView_InfiniteScroll
import SwiftDate

class InboxDetailController: BaseViewController {
    var inbox: Inbox?
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var attachImageView: UIImageView!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    @IBOutlet weak var ImageAttachContainer: UIView!
    
    var senderId: String = ""
    var inboxDetails: [InboxDetail]? = nil
    var attachment: Data?
    var page: Int = 1
    let picker = UIImagePickerController()

    static func push(on controller: UINavigationController, inbox: Inbox, senderId: String) -> InboxDetailController {
        let vc = InboxDetailController(nibName: "InboxDetailController", bundle: nil)
        vc.inbox = inbox
        vc.senderId = senderId
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.initView()
            self.tryLoadInboxDetail(inboxId: self.inbox!.ticketId!, isLatest: true)
        }
    }
    
    fileprivate func tryLoadInboxDetail(inboxId: String, isLatest: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetInboxDetail(page: isLatest ? 1 : self.page, inboxId: inboxId, complete: {response in
            self.loadingView.isHidden = true
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.tryLoadInboxDetail(inboxId: inboxId, isLatest: isLatest)
                        })
                    }
                })
                return
            }
            if let data = response.data, let inboxDetails = data.inboxDetails, !inboxDetails.isEmpty {
                if isLatest {
                    let details = self.removeSameDatas(inboxDetails: inboxDetails)
                    if !details.isEmpty {
                        if self.inboxDetails == nil {
                            self.inboxDetails = []
                        }
                        self.inboxDetails!.append(contentsOf: details)
                    }
                } else {
                    let details = self.removeSameDatas(inboxDetails: inboxDetails)
                    if !details.isEmpty {
                        self.page += 1
                        self.inboxDetails!.append(contentsOf: details)
                    }
                }
                if self.inboxDetails != nil && !self.inboxDetails!.isEmpty {
                    if self.inboxDetails!.count > 1 {
                        self.inboxDetails!.sort(by: {a,b in
                            if let aDate = a.date, let bDate = b.date {
                                return aDate.timeIntervalSince1970 <= bDate.timeIntervalSince1970
                            } else {
                                return false
                            }
                        })
                    }
                    self.tableView.reloadData()
                    if isLatest {
                        self.tableView.scrollToBottom()
                    }
                }
            }
        })
    }
    
    fileprivate func removeSameDatas(inboxDetails: [InboxDetail]) -> [InboxDetail] {
        if self.inboxDetails == nil || self.inboxDetails!.isEmpty {
            return inboxDetails
        }
        var temp = inboxDetails
        for i in (0..<inboxDetails.count).reversed() {
            for detail in self.inboxDetails! {
                if temp[i].id == detail.id {
                    temp.remove(at: i)
                    break
                }
            }
        }
        return temp
    }
    
    fileprivate func initView() {
        if let inbox = self.inbox {
            self.title = inbox.subject
        }
        self.arrowRightImageView.image = arrowRightImageView.image?.withRenderingMode(.alwaysTemplate)
        self.arrowRightImageView.tintColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "IncomingTextMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingTextMessageCell")
        self.tableView.register(UINib(nibName: "IncomingImageMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingImageMessageCell")
        self.tableView.register(UINib(nibName: "OutcomingTextMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomingTextMessageCell")
        self.tableView.register(UINib(nibName: "OutcomingImageMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomingImageMessageCell")
    }
    
    override func backButtonAction(_ sender: UIBarButtonItem) {
        if let navigation = self.navigationController as? BaseNavigationController {
            self.moveSafeAreaInsets()
            navigation.setNavigationBarHidden(true, animated: true)
            navigation.navigationBar.barTintColor = UIColor.primary
        }
        super.backButtonAction(sender)
    }

    @IBAction func sendButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        let message = inputTextField.text!
        if !message.isEmpty {
            self.tryAddInbox(ticketId: self.inbox!.ticketId!, message: message, attachment: self.attachment)
        }
    }
    
    @IBAction func attachButtonAction(_ sender: Any) {
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
    
    fileprivate func tryAddInbox(ticketId: String, message: String, attachment: Data?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpPostInboxDetail(ticketId: ticketId, subjectDetail: message, attachment: attachment, complete: {response in
            self.inputTextField.text = ""
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) || error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.tryAddInbox(ticketId: ticketId, message: message, attachment: attachment)
                            })
                        }
                    })
                    return
                }
            }
            self.tryLoadInboxDetail(inboxId: self.inbox!.ticketId!, isLatest: true)
        })
    }
    
    func infiniteScroll(tableview: UITableView) -> () {
        self.tryLoadInboxDetail(inboxId: self.inbox!.ticketId!, isLatest: true)
    }
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl!.beginRefreshing()
        self.tryLoadInboxDetail(inboxId: inbox!.ticketId!, isLatest: false)
    }

    @IBAction func deleteButonAction(_ sender: Any) {
        self.deleteAttachment()
    }
    
    fileprivate func deleteAttachment() {
        self.ImageAttachContainer.isHidden = true
        self.attachImageView.image = nil
        self.attachment = nil

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

extension InboxDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let inboxDetails = self.inboxDetails, !inboxDetails.isEmpty {
            count += inboxDetails.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inboxDetail = self.inboxDetails![indexPath.row]
        if inboxDetail.userId! == senderId {
            if let attach = inboxDetail.attachment, !attach.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingImageMessageCell", for: indexPath) as! OutcomingImageMessageCell
                cell.messageLabel.text = inboxDetail.message
                cell.usernameLabel.text = inboxDetail.userName
                cell.viewController = self
                if let date = inboxDetail.date {
                    if date.isToday {
                        cell.dateLabel.text = date.formatDate(dateFormat: "hh:mm a")
                    } else {
                        cell.dateLabel.text = date.formatDate(dateFormat: "dd/MM/yyyy")
                    }
                }
                cell.messageImageView.af_setImage(withURL: URL(string: attach)!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingTextMessageCell", for: indexPath) as! OutcomingTextMessageCell
                cell.messageLabel.text = inboxDetail.message
                cell.usernameLabel.text = inboxDetail.userName
                if let date = inboxDetail.date {
                    if date.isToday {
                        cell.dateLabel.text = date.formatDate(dateFormat: "h:mm a")
                    } else {
                        cell.dateLabel.text = date.formatDate(dateFormat: "dd/MM/yyyy")
                    }
                }
                return cell
            }
        } else {
            if let attach = inboxDetail.attachment {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingImageMessageCell", for: indexPath) as! IncomingImageMessageCell
                cell.messageLabel.text = inboxDetail.message
                cell.usernameLabel.text = inboxDetail.userName
                cell.viewController = self
                if let date = inboxDetail.date {
                    if date.isToday {
                        cell.dateLabel.text = date.formatDate(dateFormat: "h:mm a")
                    } else {
                        cell.dateLabel.text = date.formatDate(dateFormat: "dd/MM/yyyy")
                    }
                }
                cell.messageImageView.af_setImage(withURL: URL(string: attach)!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingTextMessageCell", for: indexPath) as! IncomingTextMessageCell
                cell.messageLabel.text = inboxDetail.message
                cell.userNameLabel.text = inboxDetail.userName
                if let date = inboxDetail.date {
                    if date.isToday {
                        cell.dateLabel.text = date.formatDate(dateFormat: "h:mm a")
                    } else {
                        cell.dateLabel.text = date.formatDate(dateFormat: "dd/MM/yyyy")
                    }
                }
                return cell
            }
        }
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomView.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomView.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        })

    }
    
    
}

extension InboxDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: {
            if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.attachment = UIImageJPEGRepresentation(chosenImage, 0.75)
                self.ImageAttachContainer.isHidden = false
                self.attachImageView.image = UIImage(data: self.attachment!)
            }
        })
    }
}
