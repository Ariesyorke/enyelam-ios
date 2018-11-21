//
//  NVariationView.swift
//  Nyelam
//
//  Created by Bobi on 11/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NVariationView: UIView {
    fileprivate var contentView: UIView?
    fileprivate var variation: Variation?
    
    @IBOutlet weak var variationTitleLabel: UILabel!
    @IBOutlet weak var variationNameLabel: UILabel!
    @IBOutlet weak var variationContainer: UIControl!
    
    var onVariationClicked: (NVariationView, Variation) -> () = {view, variation in
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        initView()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        xibSetup()
        initView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        initView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
        initView()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NVariationView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    
    @IBAction func variationButtonAction(_ sender: Any) {
        self.onVariationClicked(self, self.variation!)
    }
    
    func initData(variation: Variation) {
        self.variation = variation
        if let variationItems = variation.variationItems, !variationItems.isEmpty {
            for variationItem in variationItems {
                if variationItem.picked {
                    self.variationNameLabel.text = variationItem.name
                    return
                }
            }
            self.variationNameLabel.text = variationItems[0].name
        } else {
            self.variationNameLabel.text = "-"
        }
    }
    
    fileprivate func initView() {
        self.variationContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.variationContainer.layer.borderWidth = 1
    }
}
