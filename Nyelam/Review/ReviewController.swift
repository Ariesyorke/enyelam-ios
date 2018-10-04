//
//  ReviewController.swift
//  Nyelam
//
//  Created by Bobi on 5/30/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import Cosmos
import MBProgressHUD

class ReviewController: BaseViewController {
    static func present(on controller: UINavigationController, serviceId: String) -> ReviewController {
        let vc: ReviewController = ReviewController(nibName: "ReviewController", bundle: nil)
        vc.serviceId = serviceId
        controller.present(vc, animated: true, completion: {})
        return vc
    }
    
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cosmosView: CosmosView!
    
    fileprivate var serviceId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dtmViewDidLoad()
        self.commentTextView.layer.borderColor = UIColor.nyGray.cgColor
        self.commentTextView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let reviewText = self.commentTextView.text!
        let rating = self.cosmosView.rating
        
        if reviewText.isEmpty {
            UIAlertController.handleErrorMessage(viewController: self, error: "Comment must not be empty!", completion: {})
            return
        }
        self.view.endEditing(true)
        self.trySubmitReview(rating: Int(rating), review: reviewText, serviceId: self.serviceId!)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollBottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }, completion: {done in
            self.doneButton.isHidden = false
        })
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        self.doneButton.isHidden = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func trySubmitReview(rating: Int, review: String, serviceId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpSubmitReview(serviceId: serviceId, rating: String(rating), review: review, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.trySubmitReview(rating: rating, review: review, serviceId: serviceId)
                    })
                }
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Review Success Created!", actionButtonTitle: "OK", completion: {
                self.dismiss(animated: true, completion: nil)
            })

        })
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
