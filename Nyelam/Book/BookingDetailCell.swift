//
//  BookingDetailCell.swift
//  Nyelam
//
//  Created by Bobi on 5/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos

class BookingDetailCell: NTableViewCell {
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var diveCenterNameLabel: UILabel!
    @IBOutlet weak var diveCenterLocationName: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(diveService: NDiveService, selectedDate: Date) {
        self.eventLabel.text = diveService.name
        self.rateView.rating = diveService.rating
        self.bookingDateLabel.text = selectedDate.formatDate(dateFormat: "dd MMMM yyyy")
        self.visitedLabel.text = "\(diveService.ratingCount) / \(diveService.visited) visited"
        if let diveCenter = diveService.divecenter {
            self.diveCenterNameLabel.text = diveCenter.name
            if let location = diveCenter.location {
                self.diveCenterLocationName.text = "\(diveCenter.location!.city!), \(diveCenter.location!.province!) - \(diveCenter.location!.country!)"
            }
        }
    }
}
