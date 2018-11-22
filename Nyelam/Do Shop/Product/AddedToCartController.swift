//
//  AddedToCartController.swift
//  Nyelam
//
//  Created by Bobi on 11/22/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import PopupController

class AddedToCartController: BaseViewController, PopupContentViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var specialPriceLabel: UILabel!
    @IBOutlet weak var normalPriceContainer: UIView!
    @IBOutlet weak var normalPriceLabel: UILabel!
    
    fileprivate var popupSize: CGSize = CGSize.zero
    fileprivate var product: NProduct?
    var onGoToCart: ()->() = {}
    var onContinueShopping: ()->() = {}
    
    static func create(product: NProduct, size: CGSize) -> AddedToCartController {
        let vc = AddedToCartController(nibName: "AddedToCartController", bundle: nil)
        vc.product = product
        vc.popupSize = size
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData(product: self.product!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return self.popupSize
    }

    @IBAction func shopButtonAction(_ sender: Any) {
        self.onContinueShopping()
    }
    
    @IBAction func gotoCartButtonAction(_ sender: Any) {
        self.onGoToCart()
    }
    
    fileprivate func initData(product: NProduct) {
        if let imageUrl = product.featuredImage, let url = URL(string: imageUrl) {
            self.productImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "image_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
        }
        if product.normalPrice == product.specialPrice {
            self.normalPriceContainer.isHidden = true
        } else {
            self.normalPriceContainer.isHidden = false
            self.normalPriceLabel.text = product.normalPrice.toCurrencyFormatString(currency: "Rp")
        }
        self.specialPriceLabel.text = product.specialPrice.toCurrencyFormatString(currency: "Rp")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
