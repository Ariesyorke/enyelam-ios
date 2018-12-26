//
//  BaseNavigationController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BaseNavigationController: UINavigationController, UITextFieldDelegate {
    var dismissCompletion: ()->() = {}
    var firstime: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        dtmViewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.primary
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font:UIFont(name: "FiraSans-Bold", size: 18.0)!]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInnerPushNotification(userInfo: [AnyHashable: Any]) {
        if let inboxJsonString = userInfo["gcm.notification.inbox"] as? String {
            do {
                if let authReturn = NAuthReturn.authUser(), let user = authReturn.user {
                    let data = inboxJsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                    let inboxJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    let inbox = Inbox(json: inboxJson)
                    
                    if let topViewController = self.topViewController as? InboxDetailController {
                        if let inbx = topViewController.inbox {
                            if inbox.ticketId == inbx.ticketId {
                                return
                            }
                        }
                    }
                    
                    var closed = true
                    if let status = inbox.status, status.lowercased() == "open" {
                        closed = false
                    }

                    var subtitle: String = ""
                    var title: String = ""
                    if let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? [String: Any] {
                        if let message = alert["body"] as? String {
                            subtitle = message
                        }
                        if let t = alert["title"] as? String {
                            title = t
                        }
                    } else if let notification = userInfo["notification"] as? [AnyHashable: Any] {
                        if let message = notification["body"] as? String {
                            subtitle = message
                        }
                        if let t = notification["title"] as? String {
                            title = t
                        }
                    }
                    let banner = NotificationBanner(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: .info, colors: nil)
                    banner.onTap = {
                        let _ = InboxDetailController.push(on: self, inbox: inbox, senderId: user.id!, closed: closed)
                    }
                    banner.show()
                }
            } catch {
                print(error)
            }
        }
    }
}
