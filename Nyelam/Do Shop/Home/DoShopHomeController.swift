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

class DoShopHomeController: BaseViewController {
    @IBOutlet weak var collectionView: CollectionView!
    
    internal var productGridSize: CGSize!
    internal var categoryGridSize: CGSize!
    internal var productDataSource: ArrayDataSource<NProduct> = ArrayDataSource()
    internal var categoryDataSource: ArrayDataSource<NProductCategory> = ArrayDataSource()
    
    internal var refreshControl: UIRefreshControl!
    internal var sideMenuNavController: DoShopSideMenuNavigationController?
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_navigation_drawer"), style: .plain, target: self, action: #selector(DoShopHomeController.onNavigation(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_cart"), style: .plain, target: self, action: #selector(DoShopHomeController.onCart(_:)))
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
    @objc func onCart(_ sender: UIBarButtonItem) {
        if let authUser = NAuthReturn.authUser() {
            let _ = CartController.push(on: self.navigationController!)
        } else {
            self.goToAuth(completion: {
                let _ = CartController.push(on: self.navigationController!)
            })
        }
    }
    fileprivate func initCollectionView() {
        let productViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: ProductGridView, data: NProduct, index: Int) in
            view.initData(product: data)
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
                                                                let filter = DoShopFilter()
                                                                filter.categoryId = context.data.id!
                                                                let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                                                                
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
                                                            .inset(by: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)),
                                                           animator: nil,
                                                           tapHandler: {context in
                                                           
        })
        
        let finalProvider = ComposedProvider(sections: [categoryProvider, productHeaderProvider, productProvider])
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
