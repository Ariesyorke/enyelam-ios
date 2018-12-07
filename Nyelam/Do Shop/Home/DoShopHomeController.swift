//
//  DoShopHomeController.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CollectionKit
import SideMenu

class DoShopHomeController: BaseDoShopViewController {
    @IBOutlet weak var collectionView: CollectionView!
    
    fileprivate var productGridSize: CGSize!
    fileprivate var categoryGridSize: CGSize!
    fileprivate var bannerSize: CGSize!
    fileprivate var productDataSource: ArrayDataSource<NProduct> = ArrayDataSource()
    fileprivate var categoryDataSource: ArrayDataSource<NProductCategory> = ArrayDataSource()
    
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var sideMenuNavController: DoShopSideMenuNavigationController?
    
    var searchController : UISearchController?

    static func push(on controller: UINavigationController) -> DoShopHomeController {
        let vc = DoShopHomeController(nibName: "DoShopHomeController", bundle: nil)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(DoShopHomeController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.collectionView.addSubview(self.refreshControl)
        
        let categoryLabelH = CGFloat(14)
        let nameLabelH = CGFloat(16)
        let codeLabelH = CGFloat(21)
        let priceLabelH = CGFloat(16)
        let contentH = categoryLabelH + nameLabelH + codeLabelH + priceLabelH
        let screenWidth: CGFloat = CGFloat(Float(UIScreen.main.bounds.size.width))
        let columnCount = 2
        let columnWidth: CGFloat = (screenWidth  - 40) / CGFloat(columnCount)
        let categoryColumnWidth: CGFloat = (screenWidth - 8)/CGFloat(columnCount)
        let imageH: CGFloat = columnWidth - 32
        
        self.productGridSize = CGSize(width: columnWidth, height: imageH + contentH + (40))
        self.categoryGridSize = CGSize(width: categoryColumnWidth, height: categoryColumnWidth)
        self.bannerSize = CGSize(width: screenWidth, height: (screenWidth * 2)/3)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_navigation_drawer"), style: .plain, target: self, action: #selector(DoShopHomeController.onNavigation(_:)))
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController!.searchResultsUpdater = self
        self.searchController!.delegate = self
        self.searchController!.searchBar.placeholder = "Enter keywords..."
        self.searchController!.searchBar.delegate = self
        self.searchController!.hidesNavigationBarDuringPresentation = false
        self.searchController!.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = self.searchController!.searchBar
        self.definesPresentationContext = true
        
        self.setupSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func onRefresh(_ sender: UIControl) {
        self.categoryDataSource.data = []
        self.productDataSource.data = []
        self.tryLoadHomepageDoShop()
    }
    
    @objc func onNavigation(_ sender: UIBarButtonItem) {
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    fileprivate func initCollectionView() {
        let productViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: ProductGridView, data: NProduct, index: Int) in
            view.initData(product: data)
        })
        
        let bannerSectionViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: SectionBannerView, data: String, index: Int) in
            view.loadBanner()
            view.isUserInteractionEnabled = true
        })
        
        let productSectionViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: SectionHeaderView, data: String, index: Int) in
            view.label.text = data
        })
        
        let categoryViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: CategoryGridView, data: NProductCategory, index: Int) in
            view.initData(category: data)
        })
        
        let categoryProvider: BasicProvider = BasicProvider(dataSource: self.categoryDataSource,
                                                            viewSource: categoryViewSource,
                                                            sizeSource: {
                                                                (index: Int, data: NProductCategory, maxSize: CGSize) in
                                                                return self.categoryGridSize
                                                            },
                                                            layout: FlowLayout(spacing: 8, justifyContent: .start, alignItems: .start)
                                                                .inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)),
                                                            animator: nil,
                                                            tapHandler: {context in
                                                                if context.data.id! == "-1" {
                                                                    let _ = CategoryViewController.push(on: self.navigationController!)
                                                                } else {
                                                                    let filter = DoShopFilter()
                                                                    filter.categoryId = context.data.id!
                                                                    let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                                                                }
                                                                
        })
        
        let productProvider: BasicProvider = BasicProvider(dataSource: self.productDataSource,
                                                            viewSource: productViewSource,
                                                            sizeSource: {
                                                                (index: Int, data: NProduct, maxSize: CGSize) in
                                                                return self.productGridSize
        },
                                                            layout: FlowLayout(spacing: 8, justifyContent: .start, alignItems: .start)
                                                                .inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)),
                                                            animator: nil,
                                                            tapHandler: {context in
                                                                let _ = DoShopProductDetailController.push(on: self.navigationController!, productId: context.data.productId!)
                                                                
        })
        
        let productHeaderProvider: BasicProvider = BasicProvider(dataSource: ArrayDataSource(data: ["RECOMMENDED FOR YOU"]),
                                                           viewSource: productSectionViewSource,
                                                           sizeSource: {
                                                            (index: Int, data: String, maxSize: CGSize) in
                                                            return CGSize(width: self.view.frame.width, height: 50)
        },
                                                           layout: FlowLayout(spacing: 1, justifyContent: .start, alignItems: .start)
                                                            .inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)),
                                                           animator: nil,
                                                           tapHandler: {context in
                                                           
        })
        
        let bannerProvider: BasicProvider = BasicProvider(dataSource: ArrayDataSource(data: [""]),
                                                                 viewSource: bannerSectionViewSource,
                                                                 sizeSource: {
                                                                    (index: Int, data: String, maxSize: CGSize) in
                                                                    return self.bannerSize
        },
                                                                 layout: FlowLayout(spacing: 1, justifyContent: .start, alignItems: .start)
                                                                    .inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)),
                                                                 animator: nil,
                                                                 tapHandler: {context in
                if let banners = context.view.doShopBanners, !banners.isEmpty {
                        let banner = banners[context.view.index]
                            if let type = banner.bannerType {
                                if type.lowercased() == "url", let target = banner.target, let url = URL(string: target) {
                                        if #available(iOS 10.0, *) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        } else {
                                            UIApplication.shared.openURL(url)
                                        }
                                } else if type.lowercased() == "product", let target = banner.target {
                                    let _ = DoShopProductDetailController.push(on: self.navigationController!, productId: target)
                                } else if type.lowercased()  == "category", let target = banner.target {
                                    let filter = DoShopFilter()
                                    filter.categoryId = target
                                    let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                                } else if type.lowercased() == "brand", let target = banner.target {
                                    let filter = DoShopFilter()
                                    filter.brandId = target
                                    let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                                }
                            }
                        }
        })

        
        let finalProvider = ComposedProvider(sections: [bannerProvider, categoryProvider, productHeaderProvider, productProvider])
        self.collectionView.provider = finalProvider
    }
    
    fileprivate func tryLoadHomepageDoShop() {
        NHTTPHelper.httpGetFeaturedDoShop(complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                
            }
            if let data = response.data {
                if let categories = data.categories, !categories.isEmpty {
                    self.categoryDataSource.data = categories
                }
                if let products = data.products, !products.isEmpty {
                    self.productDataSource.data = products
                }
                self.initCollectionView()
            }
        })
    }
    
    fileprivate func setupSideMenu() {
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        self.sideMenuNavController = DoShopSideMenuNavigationController.create()
        sideMenuNavController!.setNavigationBarHidden(true, animated: false)
        sideMenuNavController!.onSideMenuClicked = {sideMenu, category in
            self.openSideMenu(sideMenu: sideMenu, category: category)
        }
        SideMenuManager.menuLeftNavigationController = sideMenuNavController
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: UIRectEdge.left)
    }
    
    fileprivate func openSideMenu(sideMenu: DoShopSideMenuType, category: NProductCategory?) {
        switch  sideMenu {
        case .order:
            self.sideMenuNavController!.dismiss(animated: true, completion: {
                if let authUser = NAuthReturn.authUser() {
                    let _ = OrderViewController.push(on: self.navigationController!)
                } else {
                    self.goToAuth(completion: {
                        let _ = OrderViewController.push(on: self.navigationController!)
                    })
                }
            })
            break
        case .category:
            self.sideMenuNavController!.dismiss(animated: true, completion: {
                if let category = category {
                    let filter = DoShopFilter()
                    filter.categoryId = category.id!
                    let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                }
            })
            break
        default:
            self.navigationController!.dismiss(animated: true, completion: {
                self.navigationController!.dismiss(animated: true, completion: nil)
            })
            break
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        
    }
    override func keyboardWillHide(animationDuration: TimeInterval) {
        
    }
}

extension DoShopHomeController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        var keyword = searchBar.text!
        if !keyword.isEmpty {
            let filter = DoShopFilter()
            filter.keyword = keyword
            let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
        } else {
            UIAlertController.handleErrorMessage(viewController: self, error: "Keyword cannot be empty!", completion: {})
        }
        
    }
}

class SectionBannerView: UIView, UIScrollViewDelegate {
    var index: Int = 0
    var doShopBanners: [DoShopBanner]? {
        didSet {
            if let banners = self.doShopBanners, !banners.isEmpty {
                for subview in self.scrollView.subviews {
                    subview.removeFromSuperview()
                }
                var i = 0
                var leftView: UIView? = nil
                for banner in banners {
                    let view = self.createView(for: banner.bannerImage ?? "", width: self.frame.width, height: (self.frame.width * 2 / 3),at: i)
                    self.scrollView.addSubview(view)
                    self.scrollView.addConstraints([NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1, constant: 0),NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1, constant: 0),
                                                               NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: 1, constant: 0)])
                    if leftView == nil {
                        self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
                    } else {
                        self.scrollView.addConstraint(NSLayoutConstraint(item: leftView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
                    }
                    self.scrollView.delegate = self
                    if i >= banners.count - 1 {
                        self.scrollView.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.scrollView, attribute: .trailing, multiplier: 1, constant: 0))
                    }
                    leftView = view
                    i += 1

                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let gap = Int((scrollView.contentSize.width - scrollView.contentOffset.x)/scrollView.bounds.width)
        self.index = Int(self.doShopBanners!.count - gap)
        
    }
    
    fileprivate func createView(for image: String, width: CGFloat, height: CGFloat, at index: Int) -> UIView {
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addConstraints([NSLayoutConstraint(item: control, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width), NSLayoutConstraint(item: control, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)])
        control.tag = index
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        control.addSubview(imageView)
        control.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: control, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: control, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: control, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: control, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        if let url = URL(string: image) {
            imageView.af_setImage(withURL: url)
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(named: "image_default")
            imageView.contentMode = .scaleAspectFill
        }
        
        return control
    }

    var scrollView: UIScrollView! {
        if _scrollView == nil {
            _scrollView = UIScrollView()
            _scrollView!.translatesAutoresizingMaskIntoConstraints = false
            _scrollView!.isPagingEnabled = true
            _scrollView!.showsHorizontalScrollIndicator = false
            self.addSubview(_scrollView!)
            self.addConstraints([
                NSLayoutConstraint(item: _scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: _scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: _scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: _scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
                ])
        }
        return _scrollView!
    }
    
    fileprivate var _scrollView: UIScrollView?

    func loadBanner() {
        NHTTPHelper.httpGetDoShopBanners(complete: {response in
            if let datas = response.data, !datas.isEmpty {
                self.doShopBanners = datas
            }
        })
    }
}
class SectionHeaderView: UIView {
    var label: UILabel! {
        if _label == nil {
            _label = UILabel()
            _label!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(_label!)
            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: _label, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: _label, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                ])
            _label!.font = UIFont(name: "FiraSans-Bold", size: 14)
            _label!.textColor = UIColor.black
            _label!.textAlignment = NSTextAlignment.center
        }
        return _label
    }
    fileprivate var _label: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
}

enum DoShopSideMenuType {
    case order
    case category
    case exit
}
