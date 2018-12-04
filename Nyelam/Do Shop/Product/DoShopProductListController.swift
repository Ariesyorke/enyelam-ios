//
//  DoShopProductListController.swift
//  Nyelam
//
//  Created by Bobi on 11/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CollectionKit
import UIScrollView_InfiniteScroll
import ActionSheetPicker_3_0

class DoShopProductListController: BaseViewController {
    @IBOutlet weak var collectionView: CollectionView!
    fileprivate var refreshControl: UIRefreshControl = UIRefreshControl()
    fileprivate var filter: DoShopFilter = DoShopFilter()
    fileprivate var page: Int = 1
    fileprivate var productDataSource: ArrayDataSource<NProduct> = ArrayDataSource()
    fileprivate var productGridSize: CGSize!
    fileprivate var nextPage: Int = -1
    fileprivate var searchController : UISearchController?

    static func push(on controller: UINavigationController, filter: DoShopFilter) -> DoShopProductListController {
        let vc = DoShopProductListController(nibName: "DoShopProductListController", bundle: nil)
        vc.filter = filter
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_cart"), style: .plain, target: self, action: #selector(DoShopProductListController.onCart(_:)))
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(DoShopProductListController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.addInfiniteScroll(handler: {scrollView in
            if self.nextPage > 0 {
                self.tryLoadProductList(filter: self.filter)
            } else {
                self.collectionView.finishInfiniteScroll()
            }
        })
        
        let categoryLabelH = CGFloat(14)
        let nameLabelH = CGFloat(16)
        let codeLabelH = CGFloat(21)
        let priceLabelH = CGFloat(16)
        let contentH = categoryLabelH + nameLabelH + codeLabelH + priceLabelH
        let screenWidth: CGFloat = CGFloat(Float(UIScreen.main.bounds.size.width))
        let columnCount = 2
        let columnWidth: CGFloat = (screenWidth  - 40) / CGFloat(columnCount)
        let imageH: CGFloat = columnWidth - 32
        
        self.productGridSize = CGSize(width: columnWidth, height: imageH + contentH + (40))
        self.initCollectionView()
        if self.filter.keyword != nil && self.filter.keyword!.isEmpty {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupSearch(keyword: String) {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController!.searchResultsUpdater = self
        self.searchController!.delegate = self
        self.searchController!.searchBar.placeholder = "Enter keywords..."
        self.searchController!.searchBar.delegate = self
        self.searchController!.hidesNavigationBarDuringPresentation = false
        self.searchController!.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = self.searchController!.searchBar
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        }
    }
    

    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.page = 1
        self.nextPage = -1
        self.productDataSource.data = []
        self.collectionView.reloadData()
        self.tryLoadProductList(filter: filter)
        
    }
    
    
    fileprivate func tryLoadProductList(filter: DoShopFilter) {
        NHTTPHelper.httpGetProductList(page: self.page, keyword: filter.keyword, categoryId: filter.categoryId, priceMin: filter.priceMin, priceMax: filter.priceMax, sortBy: filter.sortBy, merchantId: filter.merchantId, complete: {response in
            self.refreshControl.endRefreshing()
            self.collectionView.finishInfiniteScroll()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadProductList(filter: filter)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                    })
                }
            }
            if let data = response.data {
                self.page += 1
                self.nextPage = data.next
                if let datas = data.products, !datas.isEmpty {
                    self.productDataSource.data.append(contentsOf: datas)
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    fileprivate func initCollectionView() {
        let productViewSource: ClosureViewSource = ClosureViewSource(viewUpdater: {
            (view: ProductGridView, data: NProduct, index: Int) in
            view.initData(product: data)
        })

        let provider: BasicProvider = BasicProvider(dataSource: self.productDataSource,
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

        self.collectionView.provider = provider
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

    
    override func keyboardWillHide(animationDuration: TimeInterval) {
    
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        
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

extension DoShopProductListController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let keyword = searchBar.text!
        if !keyword.isEmpty {
            self.filter.keyword = keyword
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        } else {
            UIAlertController.handleErrorMessage(viewController: self, error: "Keyword cannot be empty!", completion: {})
        }
        
    }
}


class DoShopFilter {
    var keyword: String?
    var categoryId: String?
    var priceMin: Double?
    var priceMax: Double?
    var sortBy: Int = 1
    var merchantId: String?
    
}
