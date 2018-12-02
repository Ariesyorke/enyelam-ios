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

class DoShopProductListController: UIViewController {
    @IBOutlet weak var collectionView: CollectionView!
    fileprivate var refreshControl: UIRefreshControl = UIRefreshControl()
    fileprivate var filter: DoShopFilter = DoShopFilter()
    fileprivate var page: Int = 1
    fileprivate var productDataSource: ArrayDataSource<NProduct> = ArrayDataSource()
    fileprivate var productGridSize: CGSize!

    static func push(on controller: UINavigationController, filter: DoShopFilter) {}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(DoShopProductListController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.addInfiniteScroll(handler: {scrollView in
            self.tryLoadProductList(filter: self.filter)
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.page = 1
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
            if let datas = response.data, !datas.isEmpty {
                self.page += 1
                self.productDataSource.data.append(contentsOf: datas)
                self.collectionView.reloadData()
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
        })

        self.collectionView.provider = provider
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

class DoShopFilter {
    var keyword: String?
    var categoryId: String?
    var priceMin: Double?
    var priceMax: Double?
    var sortBy: Int = 1
    var merchantId: String?
    
}
