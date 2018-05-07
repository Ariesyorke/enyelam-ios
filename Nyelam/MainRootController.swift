//
//  MainRootController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class MainRootController: BaseViewController {
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var tabContainer: UIView!
    @IBOutlet weak var tabMenuHome: MainRootTabItemView!
    @IBOutlet weak var tabMenuOrder: MainRootTabItemView!
    @IBOutlet weak var tabMenuAccount: MainRootTabItemView!
    
    var tabMenus: [MainRootTabItemView] {
        return [tabMenuHome, tabMenuOrder, tabMenuAccount]
    }
    var tabMenuTypes: [TabItemType] {
        return [TabItemType.Home, TabItemType.Order, TabItemType.Account]
    }
    var currentController: UIViewController?
    var homeController: HomeController?
    var accountController: AccountTableViewController?
    var bookingController: BookingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        self.onClick(tabItem: self.tabMenus.first!)
        self.disableLeftBarButton()
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func onSelectTab(type: TabItemType) {
        if type == TabItemType.Home {
            if self.currentController != nil && self.currentController == self.homeController {
                return
            }
            
            if self.homeController == nil {
                self.homeController = HomeController(nibName: "HomeController", bundle: nil)
                self.homeController!.view.translatesAutoresizingMaskIntoConstraints = false
            }
            self.put(controller: self.homeController!)
        } else if type == TabItemType.Account {
            if self.currentController != nil && self.currentController == self.accountController {
                return
            }

            if self.accountController == nil {
                self.accountController = AccountTableViewController(nibName: "AccountTableViewController", bundle: nil)
                self.accountController!.view.translatesAutoresizingMaskIntoConstraints = false
            }
            self.put(controller: self.accountController!)
        } else if type == TabItemType.Order {
            if self.currentController != nil && self.currentController == self.bookingController {
                return
            }
            if self.bookingController == nil {
                self.bookingController = BookingViewController(nibName: "BookingViewController", bundle: nil)
                self.bookingController!.view.translatesAutoresizingMaskIntoConstraints = false
            }
            self.put(controller: self.bookingController!)
        }
    }
    
    @IBAction func onClick(tabItem: MainRootTabItemView) {
        var index: Int = 0
        for tab: MainRootTabItemView in self.tabMenus {
            tab.tabSelected = tab == tabItem
            if tab == tabItem {
                if NAuthReturn.authUser() == nil && (index == 1 || index == 2) {
                    self.goToAuth()
                    return
                }
                self.onSelectTab(type: self.tabMenuTypes[index])
            }
            index += 1
        }
    }
    
    fileprivate func put(controller: UIViewController) {
        self.addChildViewController(controller)
        self.contentContainer.addSubview(controller.view)
        self.contentContainer.addConstraints([
            NSLayoutConstraint(item: self.contentContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: controller.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentContainer, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: controller.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: controller.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentContainer, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: controller.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            ])
        controller.didMove(toParentViewController: self)
        
        if self.currentController != nil {
            self.currentController!.willMove(toParentViewController: nil)
            self.currentController!.view.removeFromSuperview()
            self.currentController!.removeFromParentViewController()
        }
        
        self.currentController = controller
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func goToAuth() {
        let _ = AuthNavigationController.present(on: self, dismissCompletion: {
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            self.checkLoginState()
        })
    }

    func checkLoginState() {
        var index = 0
        if let _ = NAuthReturn.authUser() {
            for tab: MainRootTabItemView in self.tabMenus {
                if tab.tabSelected {
                    self.onSelectTab(type: self.tabMenuTypes[index])
                }
                index += 1
            }
        } else {
            for tab: MainRootTabItemView in self.tabMenus {
                if index == 0 {
                    tab.tabSelected = true
                } else {
                    tab.tabSelected = false
                }
                index += 1
            }
        }
    }

}

// MARK: - MainRootTabItemView
class MainRootTabItemView: UIControl {
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var tabSelected: Bool = false {
        didSet {
            self.backgroundColor = self.tabSelected ? UIColor.blueActive : UIColor.clear
            self.bottomLineView.backgroundColor = self.tabSelected ? UIColor.yellowActive : UIColor.clear
        }
    }
}

// MARK: - TabItemType
enum TabItemType {
    case Home
    case Order
    case Account
}
