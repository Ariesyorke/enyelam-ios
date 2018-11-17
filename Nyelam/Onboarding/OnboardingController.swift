//
//  OnboardingController.swift
//  Nyelam
//
//  Created by Bobi on 8/13/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import EAIntroView

class OnboardingController: UIViewController {
    let images = ["onboarding_1", "onboarding_2", "onboarding_3"]
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage: Int = 0
    var initOnboarding: Bool = true
    var contentViews: [UIView] = []
    
    static func present(on controller: UIViewController) -> OnboardingController {
        let vc = OnboardingController(nibName: "OnboardingController", bundle: nil)
        controller.present(vc, animated: true, completion: nil)
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.initOnboarding {
            self.initOnboarding = false
            self.createOnboarding()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if self.currentPage < images.count {
            self.currentPage += 1
            let rect = CGRect(x: self.scrollView.bounds.width * CGFloat(self.currentPage), y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            self.scrollView.scrollRectToVisible(rect, animated: true)
            self.pageControl.currentPage = self.currentPage
        } else {
            let _ = MainNavigationController.present(on: self)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let _ = MainNavigationController.present(on: self)
    }
    
    fileprivate func createView(atindex: Int) -> UIView {
        let onboardingView = OnboardingView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        onboardingView.onboardingImageView.image = UIImage(named: self.images[atindex])
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        return onboardingView
    }
    
    fileprivate func createOnboarding() {
        self.pageControl.numberOfPages = self.images.count
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.contentViews = []
        for subview: UIView in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        var i = 0
        var leftView: UIView? = nil
        while i < self.images.count {
            let view: UIView = self.createView(atindex: i)
            view.tag = i
            self.scrollView.addSubview(view)
            self.contentViews.append(view)
            self.scrollView.addConstraints([
                NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
                ])
            
            if leftView == nil {
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
            } else {
                self.scrollView.addConstraint(NSLayoutConstraint(item: leftView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
            }
            
            if i == self.images.count - 1 {
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
            }
            i += 1
            leftView = view
        }
    }
}

extension OnboardingController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let gap = Int((scrollView.contentSize.width - scrollView.contentOffset.x)/scrollView.bounds.width)
        let index = Int(contentViews.count - gap)
        self.pageControl.currentPage = index
        self.currentPage = index
    }
}
