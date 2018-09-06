//
//  NStickyDiveGuideHeader.swift
//  Nyelam
//
//  Created by Bobi on 7/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import GSKStretchyHeaderView

class NStickyDiveGuideHeader: GSKStretchyHeaderView, UIScrollViewDelegate {
    
    @IBOutlet weak var imageProfileView: UIImageView!
    @IBOutlet weak var diveGuideLabel: UILabel!
    @IBOutlet weak var diveGuideLicenseTypeLabel: UILabel!
    @IBOutlet weak var tabLineBioView: UIView!
    @IBOutlet weak var tabLineAboutView: UIView!
    
    var delegate: NStickyDiveGuideHeaderDelegate?
    
    @IBAction func tabButtonAction(_ sender: Any) {
        if let view = sender as? UIControl {
            let index = view.tag
            if index == 0 {
                self.tabLineBioView.isHidden = false
                self.tabLineAboutView.isHidden = true
            } else {
                self.tabLineBioView.isHidden = true
                self.tabLineAboutView.isHidden = false
            }
            self.delegate!.stickyHeaderView(self, didSelectTabAt: index)
        }
    }
    
    func initUser(user: NUser) {
        self.diveGuideLabel.text = user.fullname
        if let licenseType = user.licenseType {
            self.diveGuideLicenseTypeLabel.text = licenseType.name
        }
        if let picture = user.picture, let url = URL(string: picture) {
            self.imageProfileView.af_setImage(withURL: url)
        }
    }
}

protocol NStickyDiveGuideHeaderDelegate {
    func stickyHeaderView(_ headerView: NStickyDiveGuideHeader, didSelectTabAt index: Int)
}

