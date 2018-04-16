//
//  SearchKeywordController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class SearchKeywordController: BaseViewController {
    
    static func push(on controller: UINavigationController, with handler: @escaping (SearchKeywordController, SearchResult?) -> Void) -> SearchKeywordController {
        let vc: SearchKeywordController = SearchKeywordController(nibName: "SearchKeywordController", bundle: nil)
        vc.handler = handler
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    var results: [SearchResult]? = nil
    var _searchTextField: UITextField? = nil
    var searchTextField: UITextField! {
        if _searchTextField != nil {
            return _searchTextField
        }
        
        _searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        _searchTextField!.borderStyle = UITextBorderStyle.none
        _searchTextField!.translatesAutoresizingMaskIntoConstraints = false
        _searchTextField!.placeholder = "Search here..."
        
        return _searchTextField
    }
    fileprivate var handler: (SearchKeywordController, SearchResult?) -> Void = { controller, result in }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupNavigationItem()
        
        // TODO: TESTING
        let jsonString: String = "[{\"id\":\"3\",\"name\":\"Bali\",\"type\":5},{\"id\":\"1\",\"name\":\"Bali Aqua Dive Center\",\"province\":\"Bali\",\"rating\":\"5\",\"type\":3},{\"id\":\"5\",\"name\":\"Bali Bubbles Dive Center\",\"province\":\"Bali\",\"rating\":\"4\",\"type\":3},{\"id\":\"7\",\"name\":\"Bali Trip\",\"province\":\"Bali\",\"rating\":\"0\",\"type\":3},{\"id\":\"13\",\"name\":\"Balistingray Divers\",\"province\":\"Bali\",\"rating\":\"0\",\"type\":3},{\"id\":\"14\",\"name\":\"Bali Marine Diving\",\"province\":\"Bali\",\"rating\":\"0\",\"type\":3},{\"id\":\"17\",\"name\":\"Nautilus Diving Bali\",\"province\":\"Bali\",\"rating\":\"0\",\"type\":3},{\"id\":\"18\",\"name\":\"Absolute Scuba Bali\",\"province\":\"Bali\",\"rating\":\"0\",\"type\":3},{\"id\":\"179\",\"name\":\"Go Dive Bali (1 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"180\",\"name\":\"Go Dive Bali (2 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"181\",\"name\":\"Go Dive Bali (3 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"182\",\"name\":\"Go Dive Bali (2D1N with 4 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"183\",\"name\":\"Go Dive Bali (3D2N with 5 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"184\",\"name\":\"Go Dive Bali (4D3N with 7 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4},{\"id\":\"185\",\"name\":\"Go Dive Bali (5D4N with 10 Dives)\",\"rating\":\"0\",\"license\":\"1\",\"type\":4}]"
        let json = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
        if let array: [[String: Any]] = json as? [[String: Any]] {
            self.results = []
            for j: [String: Any] in array {
                let i: SearchResult = SearchResult.generateSearchResultType(type: j["type"] as! Int, json: j)
                self.results!.append(i)
            }
        }
        self.tableView.reloadData()
        // TODO: end of testing
    }
    
    fileprivate func setupNavigationItem() {
        self.navigationItem.titleView = self.createSearchBarView(size: CGSize(width: self.view.frame.width, height: 44))
    }
    
    fileprivate func setupUI() {
        self.tableView.register(UINib(nibName: "SearchKeywordResultCell", bundle: nil), forCellReuseIdentifier: "SearchKeywordResultCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchKeywordController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results != nil ? self.results!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchKeywordResultCell = tableView.dequeueReusableCell(withIdentifier: "SearchKeywordResultCell", for: indexPath) as! SearchKeywordResultCell
        cell.searchResult = self.results![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController!.popViewController(animated: true)
        self.handler(self, self.results![indexPath.row])
    }
}

extension SearchKeywordController {
    func createSearchBarView(size: CGSize) -> UIView {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height - 8))
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size.height - 8),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size.width)
            ])
        
        let icon: UIImageView = UIImageView(image: UIImage(named: "icon_search"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = UIViewContentMode.scaleAspectFit
        icon.addConstraints([
            NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size.height - 32),
            NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: size.height - 32)
            ])
        
        view.addSubview(icon)
        view.addConstraints([
            NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])
        
        view.addSubview(self.searchTextField)
        self.searchTextField.addConstraint(NSLayoutConstraint(item: self.searchTextField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40))
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.searchTextField, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.searchTextField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.searchTextField, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])
        
        return view
    }
}
