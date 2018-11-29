//
//  PersonalInformationCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class PersonalInformationCell: NTableViewCell {
    let titles: [String] = ["Billing Address","Shipping Address"]
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var billingAddressContainer: UIView!
    var row: Int = 0 {
        didSet {
            self.addressTitleLabel.text = titles[row]
        }
    }
    var onChangeAddress: (Int) -> () = {row in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func changeBillingButtonAction(_ sender: Any) {
        self.onChangeAddress(self.row)
    }
    
    func initData(address: NAddress) {
        self.createAddressDetail(address: address, container: self.billingAddressContainer)
    }
    
    fileprivate func createAddressDetail(address: NAddress, container: UIView) {
        for subview in container.subviews {
            subview.removeFromSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "FiraSans-SemiBold", size: 14)
        titleLabel.text = address.fullname
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "FiraSans-Regular", size: 14)
        descriptionLabel.text = NHelper.formatAddress(address: address)
        descriptionLabel.numberOfLines = 0
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0)])
        
        container.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: descriptionLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: descriptionLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .top, multiplier: 1, constant: -8)])
    }

        
}
