//
//  DoShopSideMenuController.swift
//  Nyelam
//
//  Created by Bobi on 11/14/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DoShopSideMenuController: BaseViewController {
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var categories: [NProductCategory]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(DoShopSideMenuController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = UIColor.clear
        self.tableView.addSubview(self.refreshControl)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
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
    
    @objc func onRefresh(_ sender: UIControl) {
        self.categories = []
        self.tableView.reloadData()
        self.tryLoadCategories()
    }
    
    fileprivate func tryLoadCategories() {
        NHTTPHelper.httpGetMasterDoShopCategory(complete: {response in
            self.refreshControl.endRefreshing()
            if let error = response.error {
                
            }
            if let data = response.data, !data.isEmpty {
                self.categories = data
            }
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

extension DoShopSideMenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = self.categories, !categories.isEmpty {
            return categories.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let category = self.categories![indexPath.row]
        cell.textLabel!.text = category.categoryName
        if let imageUrl = category.categoryImage, let url = URL(string: imageUrl) {
            cell.imageView!.af_setImage(withURL: url, placeholderImage: UIImage(named: "image_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
        }
        return cell
    }
}
