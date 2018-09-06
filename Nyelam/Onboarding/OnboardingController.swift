//
//  OnboardingController.swift
//  Nyelam
//
//  Created by Bobi on 8/13/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import EAIntroView

class OnboardingController: UIViewController, EAIntroDelegate {
    let images = ["onboarding_1", "onboarding_2", "onboarding_3"]
    var introView: EAIntroView?
    
    static func present(on controller: UIViewController) -> OnboardingController {
        let vc = OnboardingController(nibName: "OnboardingController", bundle: nil)
        controller.present(vc, animated: true, completion: nil)
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initView() {
        let page1 = EAIntroPage.init(customViewFromNibNamed: "OnboardingView")
        let page1View: OnboardingView = page1?.customView as! OnboardingView
        page1View.onboardingImageView.image = UIImage(named: self.images[0])
        let page2 = EAIntroPage.init(customViewFromNibNamed: "OnboardingView")
        let page2View: OnboardingView = page2?.customView as! OnboardingView
        page2View.onboardingImageView.image = UIImage(named: self.images[1])
        
        let page3 = EAIntroPage.init(customViewFromNibNamed: "OnboardingView")
        let page3View: OnboardingView = page3?.customView as! OnboardingView
        page3View.onboardingImageView.image = UIImage(named: self.images[2])
        
        introView = EAIntroView(frame: self.view.bounds, andPages: [page1!, page2!, page3!])
    
        introView!.pageControl.currentPageIndicatorTintColor = UIColor.primary
        introView!.pageControl.pageIndicatorTintColor = UIColor.gray
        introView!.pageControlY = 43
        introView!.delegate = self
        introView!.swipeToExit = false
        introView!.skipButtonAlignment = .left
        introView!.skipButtonY = 48
        introView!.skipButton.setTitle("SKIP", for: .normal)
        introView!.skipButton.titleLabel?.font = UIFont(name: "FiraSans-SemiBold", size: 15)
        introView!.skipButton.setTitleColor(UIColor.darkGray, for: .normal)
        introView!.show(in: self.view, animateDuration: 0.3)
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        let _ = MainNavigationController.present(on: self)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let _ = MainNavigationController.present(on: self)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let currentPage = introView!.currentPageIndex + 1
        if currentPage < 3 {
            self.introView!.scrollToPage(for: currentPage, animated: true)
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
