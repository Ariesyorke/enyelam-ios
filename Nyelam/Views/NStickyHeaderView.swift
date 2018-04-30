//
//  NStickyHeaderView.swift
//  Nyelam
//
//  Created by Bobi on 4/27/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import GSKStretchyHeaderView

class NStickyHeaderView: GSKStretchyHeaderView, UIScrollViewDelegate {
    @IBOutlet weak var tabDetailLineView: UIView!
    @IBOutlet weak var tabReviewLineView: UIView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var delegate: NStickyHeaderViewDelegate?
    var contentViews: [UIView] = []

    var banners: [Banner]? {
        didSet {
            for subview: UIView in self.scroller.subviews {
                subview.removeFromSuperview()
            }
            if self.banners != nil {
                var i: Int = 0
                var leftView: UIView? = nil
                
                for banner: Banner in self.banners! {
                    
                    let view: UIControl = self.createView(for: banner, atindex: i)
                    view.tag = i
                    self.scroller.addSubview(view)
                    self.scroller.delegate = self
                    self.contentViews.append(view)
                    self.scroller.addConstraints([
                        NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -16),
                        NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
                        ])
                    
                    if leftView == nil {
                        self.scroller.addConstraint(NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                    } else {
                        self.scroller.addConstraint(NSLayoutConstraint(item: leftView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                    }
                    
                    if i == self.banners!.count - 1 {
                        self.scroller.addConstraint(NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
                    }
                    
                    
                    i += 1
                    leftView = view
                }
                self.pageControl.numberOfPages = self.banners!.count
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func tabButtonAction(_ sender: Any) {
        if let view = sender as? UIControl {
            let index = view.tag
            self.delegate!.stickyHeaderView(self, didSelectTabAt: index)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let gap = Int((scrollView.contentSize.width - scrollView.contentOffset.x)/scrollView.bounds.width)
        let index = Int(contentViews.count - gap)
        self.pageControl.currentPage = index
    }

    fileprivate func createView(for banner: Banner, atindex: Int) -> UIControl {
        let control: UIControl = UIControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0    ))
        control.translatesAutoresizingMaskIntoConstraints = false
        
        let progress: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.tintColor = UIColor.primary
        progress.startAnimating()
        
        control.addSubview(progress)
        control.addConstraints([
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: progress, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: progress, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])
        
        let imgView: UIImageView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.clear
//        imgView
        if let url = banner.imageUrl {
            imgView.loadImage(from: url, contentMode: .scaleToFill, with: "bg_placeholder.png")
//            imgView.af_setImage(withURL: url)
        } else {
            progress.isHidden = true
        }
        control.addSubview(imgView)
        control.addConstraints([
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            ])
        return control
    }
    
    func initBanner(images: [String]) {
        var tempBanner: [Banner] = []
        for image in images {
            var banner = Banner()
            banner.imageUrl = image
            tempBanner.append(banner)
        }
        self.banners = tempBanner
    }
//    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
//        self.contentView.backgroundColor = UIColor(red: CGFloatTranslateRange(stretchFactor, 0, 1, 15/255, 22/255), green: CGFloatTranslateRange(stretchFactor, 0, 1, 100/255, 117/255), blue: CGFloatTranslateRange(stretchFactor, 0, 1, 200/255, 207/255), alpha: 1)
//        
//    }
    
}

protocol NStickyHeaderViewDelegate {
    func stickyHeaderView(_ headerView: NStickyHeaderView, didSelectTabAt index: Int)
}
