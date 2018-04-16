//
//  SearchKeywordResultCell.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/13/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class SearchKeywordResultCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var resultNameLabel: UILabel!
    @IBOutlet weak var resultTypeLabel: UILabel!
    @IBOutlet weak var provinceNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var searchResult: SearchResult? {
        didSet {
            if self.searchResult == nil {
                return
            }
            
            let icon: UIImage?
            let type: String?
            let province: String?
            let rating: String?
            switch self.searchResult!.type {
            case 1:
                icon = UIImage(named: "icon_search_divecenter")
                type = "Dive Center"
                province = nil
                rating = String(format: "%d/5", arguments: [self.searchResult!.rating])
            case 2:
                icon = UIImage(named: "icon_search_category")
                type = "Service Category"
                province = nil
                rating = nil
            case 3:
                icon = UIImage(named: "icon_search_spot")
                type = "Spot"
                if let spot: SearchResultSpot = self.searchResult as? SearchResultSpot {
                    province = spot.province
                } else {
                    province = nil
                }
                rating = String(format: "%d/5", arguments: [self.searchResult!.rating])
            case 4:
                icon = UIImage(named: "icon_search_service")
                type = "Service"
                province = nil
                rating = String(format: "%d/5", arguments: [self.searchResult!.rating])
            case 5:
                icon = UIImage(named: "icon_search_province")
                type = "Province"
                province = nil
                rating = nil
            case 6:
                icon = UIImage(named: "icon_search_city")
                type = "City"
                province = nil
                rating = nil
            default:
                icon = nil
                type = " "
                province = nil
                rating = nil
            }
            
            self.iconView.image = icon
            self.resultNameLabel.text = self.searchResult!.name
            self.resultTypeLabel.text = type
            self.provinceNameLabel.text = province
            self.ratingLabel.text = rating
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
