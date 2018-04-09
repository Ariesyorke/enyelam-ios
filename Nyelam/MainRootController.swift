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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onSelectTab(type: TabItemType) {
        
    }
    
    @IBAction func onClick(tabItem: MainRootTabItemView) {
        var index: Int = 0
        for tab: MainRootTabItemView in self.tabMenus {
            tab.tabSelected = tab == tabItem
            if tab == tabItem {
                self.onSelectTab(type: self.tabMenuTypes[index])
            }
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
