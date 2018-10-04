//
//  OnboardingView.swift
//  Nyelam
//
//  Created by Bobi on 8/13/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class OnboardingView: UIView {
    @IBOutlet weak var onboardingImageView: UIImageView!
    var completion: () -> () = {}
    @IBAction func nextButtonAction(_ sender: Any) {
        print("NEXT BUTTON CLICKED")
        self.completion()
    }
    
}
