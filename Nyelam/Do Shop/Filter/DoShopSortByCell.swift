//
//  DoShopSortByCell.swift
//  Nyelam
//
//  Created by Bobi on 07/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import DLRadioButton

class DoShopSortByCell: NTableViewCell {
    @IBOutlet weak var sortByButton: DLRadioButton!
    
    var sortType: Int = 0
    var onChangeSort: (Int) -> () = {sortType in }
    
    @IBAction func priceSortButtonAction(_ sender: DLRadioButton) {
        self.sortType = sender.selected()!.tag
        self.onChangeSort(self.sortType)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sortByButton.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
        for otherButton in self.sortByButton.otherButtons {
            otherButton.titleLabel?.font =  UIFont(name: "FiraSans-Regular", size: 15)
        }
        // Initialization code
    }
    
    func initSort() {
        if self.sortType == 0 {
            self.sortByButton.isSelected = true
        } else {
            for otherButton in self.sortByButton.otherButtons {
                if otherButton.tag == self.sortType {
                    otherButton.isSelected = true
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
