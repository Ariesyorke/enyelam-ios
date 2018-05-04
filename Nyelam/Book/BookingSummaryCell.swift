//
//  BookingSummaryCell.swift
//  Nyelam
//
//  Created by Bobi on 5/3/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class BookingSummaryCell: NTableViewCell {
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalPriceLabel: UILabel!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var summaryContainer: UIView!
    
    var note: String = ""
    
    var delegate: UITextFieldDelegate?
    var additionalViews: [UIView]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadAdditionalFee() {
        for view in self.detailContainer.subviews {
            view.removeFromSuperview()
        }
        self.loadingView.isHidden = false
        self.summaryContainer.isHidden = true
    }
    
    func initData(note: String, cart: Cart, selectedDiver: Int, servicePrice: Double, additionals: [Additional]?) {
        self.loadingView.isHidden = true
        self.summaryContainer.isHidden = false
        self.noteTextField.text = note
        self.subTotalLabel.text = "Total price for \(selectedDiver) pax"
        self.subTotalPriceLabel.text = "\(cart.subtotal.toCurrencyFormatString(currency: "Rp")),-"
    
        var serviceAddtionalView: NAdditionalView = NAdditionalView(frame: CGRect.zero)
        serviceAddtionalView.translatesAutoresizingMaskIntoConstraints = true
        serviceAddtionalView.initData(title: "Service Trip Package x \(selectedDiver)", price: servicePrice)
        self.additionalViews = []
        for view in self.detailContainer.subviews {
            view.removeFromSuperview()
        }
        
        self.detailContainer.addSubview(serviceAddtionalView)
        self.additionalViews!.append(serviceAddtionalView)
        self.detailContainer.addConstraints([
            NSLayoutConstraint(item: self.detailContainer, attribute: .leading, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.detailContainer, attribute: .trailing, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .trailing, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.detailContainer, attribute: .top, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .top, multiplier: 1, constant: 16)
            ])
        serviceAddtionalView.addConstraint(NSLayoutConstraint(item: serviceAddtionalView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54))
        if let additionals = additionals, !additionals.isEmpty {
            var i: Int = 0
            for additional in additionals {
                var additionalView = NAdditionalView(frame: CGRect.zero)
                additionalView.translatesAutoresizingMaskIntoConstraints = false
                additionalView.initData(title: additional.title!, price: additional.value!)
                additionalView.addConstraint(NSLayoutConstraint(item: additionalView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54))
                self.detailContainer.addConstraints([
                    NSLayoutConstraint(item: self.detailContainer, attribute: .leading, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .leading, multiplier: 1, constant: 16),
                    NSLayoutConstraint(item: self.detailContainer, attribute: .trailing, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .trailing, multiplier: 1, constant: 16),
                    NSLayoutConstraint(item: self.additionalViews![i], attribute: .bottom,
                                       relatedBy: .equal, toItem: additionalView, attribute: .top,
                                       multiplier: 1, constant: 8)
                    ])
                if i >= additionals.count - 1 {
                    self.detailContainer.addConstraint(NSLayoutConstraint(item: self.detailContainer, attribute: .bottom, relatedBy: .equal, toItem: additionalView, attribute: .bottom, multiplier: 1, constant: 16))
                }
                self.additionalViews!.append(additionalView)
                i += 1
            }
        } else {
            self.detailContainer.addConstraint(NSLayoutConstraint(item: self.detailContainer, attribute: .bottom, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .bottom, multiplier: 1, constant: 16))
        }
    }
    
    
}
