//
//  DoShopBrandFilterCell.swift
//  Nyelam
//
//  Created by Bobi on 07/02/19.
//  Copyright © 2019 e-Nyelam. All rights reserved.
//

import UIKit
import TangramKit

class DoShopBrandFilterCell: NTableViewCell {
    @IBOutlet weak var flowLayout: TGFlowLayout!
    @IBOutlet weak var flowLayoutConstraintHeight: NSLayoutConstraint!
    var reloadData: ([String]?)->() = {selectedBrands in }
    
    var brands: [Brand]?
    var selectedBrands: [String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @objc func facilityButtonAction(_ sender: UIButton!) {
        let tag = sender.tag
        if !sender.isSelected {
            if self.selectedBrands == nil {
                self.selectedBrands = []
            }
            self.selectedBrands!.append(self.brands![tag].id!)
        } else {
            if let selectedBrands = self.selectedBrands {
                var i = 0
                let brand = self.brands![tag]
                for selectedBrand in selectedBrands {
                    if selectedBrand == brand.id! {
                        self.selectedBrands!.remove(at: i)
                    }
                    i += 1
                }
            }
        }

        self.reloadData(self.selectedBrands)
    }

    func initView() {
        self.flowLayout.tg_leftPadding = 16
        self.flowLayout.tg_rightPadding = 16
        self.flowLayout.tg_topPadding = 16
        self.flowLayout.tg_bottomPadding = 16
        self.flowLayout.tg_space = 8
        self.flowLayout.tg_autoArrange = false
        self.flowLayout.tg_removeAllSubviews()
        var additional: CGFloat = 0
        var i = 0
        if let brands = self.brands, !brands.isEmpty {
            for brand in brands {
                let button = UIButton()
                button.layer.cornerRadius = 5
                var selected: Bool = false
                if let selectedBrands = self.selectedBrands, !selectedBrands.isEmpty {
                    for selectedBrand in selectedBrands {
                        if selectedBrand == brand.id! {
                            selected = true
                            break
                        }
                    }
                }
                if selected {
                    additional += 4
                    button.backgroundColor = UIColor.nyOrange
                    button.setTitleColor(UIColor.white, for: .normal)
                } else {
                    button.layer.borderColor = UIColor.lightGray.cgColor
                    button.layer.borderWidth = 1
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.lightGray, for: .normal)
                }
                button.isSelected = selected
                button.tag = i
                button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
                button.setTitle(brand.name, for: .normal)
                button.tg_width.equal(button.tg_width).add(10)
                button.tg_height.equal(button.tg_height).add(15)
                button.contentHorizontalAlignment = .left
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
                button.sizeToFit()
                button.addTarget(self, action: #selector(facilityButtonAction(_:)), for: .touchUpInside)
                self.flowLayout.addSubview(button)
                i += 1
            }
            self.flowLayoutConstraintHeight.constant = 185 + additional
        }
    }
}
