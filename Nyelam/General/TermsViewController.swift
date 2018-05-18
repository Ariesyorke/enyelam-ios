//
//  TermsViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewController {
    var cancellations = [
        "When making a reservation through the e-Nyelam Apps, you agree to all terms and conditions provided by diving centers, including their cancellation policies. E-Nyelam is not responsible to any infringement caused by customer’s special requests to the diving centres. Therefore, you need to read all terms and condition carefully.",
        "In terms of customer’s cancellation, E-Nyelam has authority to hold and/or charge your payment as cancellation fees."]
    var cancellationsNumberring = ["a","b"]
    var additionalNumberring = ["a","b","c","d","e","f", "g", "h"]
    var additionals = ["All quotations are subject to the terms and conditions stated herein.",
                       "All published prices are subject to change without prior notice, depending on the amount of reservation and/or quota in the diving centers.",
                       "All published prices include tax and additional fees; however, in a certain condition, there might be additional cost required by diving centers such as guide tips, personal costs, and/or other services. Therefore, the customer is responsible to verify the total costs and other regulation before making the payment.",
                       "Cost of additional services, including the use of credit card or transfer fees, are charged to the customers. E-Nyelam will notify the customers via phone call or email if there is the lack of payment.",
                       "If the customer cancels the booking, all the payment is non-refundable.",
                       "e-Nyelam will refund the payment to the customers if cancellation is caused by force majeur. However, we will deduct it due to service fees. If you have a question, need help, or need to report a problem, please call our customer service or you may send email to:info@e-nyelam.com",
                       "We do not take any responsibility and we are not liable for any transaction caused by, but not limited to: the lack of payment.",
                       "We will annul the transaction caused by payment delays."]
    @IBOutlet weak var cancellationContentLabel: UILabel!
    @IBOutlet weak var additionalContentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms & Conditions"
        self.cancellationContentLabel.attributedText = NSAttributedString.customNumbering(array: self.cancellations, bullets: self.cancellationsNumberring, fontName: "FiraSans-Regular", size: 14, color: UIColor.black)
        self.additionalContentLabel.attributedText = NSAttributedString.customNumbering(array: self.additionals, bullets: self.additionalNumberring, fontName: "FiraSans-Regular", size: 14, color: UIColor.black)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
