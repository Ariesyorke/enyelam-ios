//
//  DiveEthicAgreementController.swift
//  Nyelam
//
//  Created by Bobi on 5/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import PopupController
import DLRadioButton

class DiveEthicAgreementController: UIViewController, PopupContentViewController {
    
    let terms = [
        "Do not litter!",
        "Avoid using items with small packagings, e.g. sachet soap.",
        "Use skin creams, sunscreen/sunblock, and bug sprays/insect repellents that are natural and non-toxic.",
        "Bring a refillable drinking bottle.",
        "Bring a bag that can be reused.",
        "Reduce the usage of single-used materials.",
        "Do not consume or eat species that are endangered, almost extinct, or protected.",
        "Avoid bringing and using products containing microbeads, e.g. soaps containing scrubs.",
        "Practice your balance to avoid bumping to coral reefs.",
        "Do not step on or touch coral reefs."
    ]
    
    var popupSize: CGSize?
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var checkButton: DLRadioButton!
    var dismissCompletion: (Bool) -> () = {completion in}
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return self.popupSize!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.termLabel.attributedText = NSAttributedString.numberringAttributedText(array: terms, fontName: "FiraSans-Regular", size: 14, color: UIColor.black)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismissCompletion(false)
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        if self.checkButton.isSelected {
            self.checkButton.isSelected = false
        } else {
            self.checkButton.isSelected = true
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if self.checkButton.isSelected {
            self.dismissCompletion(true)
        } else {
            //TODO NOTHING?
        }
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
