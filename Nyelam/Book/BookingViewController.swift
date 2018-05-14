//
//  BookingViewController.swift
//  Nyelam
//
//  Created by Bobi on 5/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BookingViewController: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        self.settings.style.buttonBarBackgroundColor = UIColor.primary
        self.settings.style.buttonBarItemFont = UIFont(name: "FiraSans-Bold", size: 14)!
        self.settings.style.buttonBarItemTitleColor = UIColor.darkGray
        self.settings.style.selectedBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemBackgroundColor = UIColor.primary
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarHeight = 66
        self.settings.style.selectedBarHeight = 3
        self.changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.white
            newCell?.label.textColor = UIColor.white
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [BookingListController.createBookingList(bookingType: 1), BookingListController.createBookingList(bookingType: 2)]
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

