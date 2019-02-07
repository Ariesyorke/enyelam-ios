//
//  CategoryViewController.swift
//  Nyelam
//
//  Created by Bobi on 06/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CollectionKit

class CategoryViewController: BaseDoShopViewController {
    @IBOutlet weak var collectionView: CollectionView!
    fileprivate var refreshControl = UIRefreshControl()
    fileprivate var categoryDataSource: ArrayDataSource<NProductCategory> = ArrayDataSource()
    fileprivate var categoryGridSize: CGSize!
    
    static func push(on controller: UINavigationController) -> CategoryViewController {
        let vc = CategoryViewController(nibName: "CategoryViewController", bundle: nil)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(DoShopHomeController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.collectionView.addSubview(self.refreshControl)
        self.title = "Categories"
        
        let categoryLabelH = CGFloat(14)
        let nameLabelH = CGFloat(16)
        let codeLabelH = CGFloat(21)
        let priceLabelH = CGFloat(16)
        let screenWidth: CGFloat = CGFloat(Float(UIScreen.main.bounds.size.width))
        let columnCount = 2
        let columnWidth: CGFloat = (screenWidth  - 24) / CGFloat(columnCount)
//        let categoryColumnWidth: CGFloat = (screenWidth - 40)/CGFloat(columnCount)
        
        self.categoryGridSize = CGSize(width: columnWidth, height: columnWidth)
        self.initCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.refreshControl.beginRefreshing()
            self.onRefresh(self.refreshControl)
        }
    }
    
    @objc func onRefresh(_ sender: UIControl) {
        self.categoryDataSource.data = []
        self.tryLoadCategories()
    }

    fileprivate func tryLoadCategories() {
        NHTTPHelper.httpGetMasterDoShopCategory(complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                self.tryLoadCategories()
            }
            if let data = response.data, !data.isEmpty {
                self.categoryDataSource.data = data
                self.collectionView.reloadData()
            }
        })
    }

    fileprivate func initCollectionView() {
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
                                                                .inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)),
                                                            animator: nil,
                                                            tapHandler: {context in
                                                                let filter = DoShopFilter()
                                                                filter.categoryId = context.data.id!
                                                                let _ = DoShopProductListController.push(on: self.navigationController!, filter: filter)
                                                                
        })
        self.collectionView.provider = categoryProvider
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

