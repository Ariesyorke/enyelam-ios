//
//  SearchKeywordController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CoreData

class SearchKeywordController: BaseViewController {
    
    static func push(on controller: UINavigationController, with handler: @escaping (SearchKeywordController, SearchResult?) -> Void) -> SearchKeywordController {
        let vc: SearchKeywordController = SearchKeywordController(nibName: "SearchKeywordController", bundle: nil)
        vc.handler = handler
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var results: [SearchResult]? = nil
    var savedResults: [SearchResult]? = nil
    
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
        self.setupSavedData()
        self.tableView.reloadData()
        // TODO: end of testing
    }
    
    fileprivate func setupSavedData() {
        if let savedResults = NSearchResult.getSavedResults() {
            self.savedResults = []
            for result in savedResults {
                var json = result.serialized()
                if let type = json["type"] as? Int {
                    var searchResult = SearchResult.generateSearchResultType(type: type, json: json)
                    self.savedResults!.append(searchResult)
                } else if let type = json["type"] as? String {
                    if type.isNumber {
                        var searchResult = SearchResult.generateSearchResultType(type: Int(type)!, json: json)
                        self.savedResults!.append(searchResult)
                    }
                }
            }
        }
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
        if section == 0 {
            if let savedResults = self.savedResults, !savedResults.isEmpty, self.results == nil || self.results!.isEmpty {
                return savedResults.count
            } else {
                return self.results != nil ? self.results!.count : 0
            }
        } else {
            return self.savedResults != nil ? self.savedResults!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchKeywordResultCell = tableView.dequeueReusableCell(withIdentifier: "SearchKeywordResultCell", for: indexPath) as! SearchKeywordResultCell
        cell.searchResult = self.results![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var result: SearchResult? = nil
        var pickedFromServer: Bool = false
        if indexPath.section == 0 {
            if let savedResults = self.savedResults, !savedResults.isEmpty, (self.results == nil || self.results!.isEmpty)  {
                result = savedResults[indexPath.row]
            } else {
                pickedFromServer = true
                result = self.results![indexPath.row]
            }
        } else {
            result = savedResults![indexPath.row]
        }
        if pickedFromServer {
            var searchResult = NSearchResult.getSavedResult(using: String(result!.type), and: (result!.name!))
            if searchResult == nil {
                searchResult = NSEntityDescription.insertNewObject(forEntityName: "NSearchResult", into: AppDelegate.sharedManagedContext) as! NSearchResult
                searchResult!.parse(json: result!.serialized())
                NSManagedObjectContext.saveData()
            }
        }
        self.handler(self, result!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var section = 0
        if let results = self.results, !results.isEmpty {
            section += 1
        }
        if let results = self.savedResults, !results.isEmpty {
            section += 1
        }
        return section
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let savedResults = self.savedResults, !savedResults.isEmpty, (self.results == nil || !self.results!.isEmpty) {
                return self.savedResultHeader()
            }
            return nil
        } else {
            return self.savedResultHeader()
        }
        return nil
    }
    
    fileprivate func savedResultHeader()->UIView {
        let header: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        header.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let label: UILabel = UILabel(frame: CGRect(x: 16, y: 8, width: tableView.frame.width - 32, height: 40 - 16))
        label.text = "Recent Search"
        label.textColor = UIColor(white: 0.3, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        header.addSubview(label)
        return header

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
        self.searchTextField.delegate = self
        self.searchTextField.addConstraint(NSLayoutConstraint(item: self.searchTextField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40))
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.searchTextField, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.searchTextField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.searchTextField, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])
        
        return view
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NHTTPHelper.httpCancelRequest(apiUrl: NHTTPHelper.API_PATH_MASTER_DO_DIVE_SEARCH)
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let keyword = text.replacingCharacters(in: textRange,
                                                       with: string)
            if keyword.count >= 3 {
                self.trySearch(with: keyword)
            }
        }
        return true
    }

    func trySearch(with keyword: String) {
        NHTTPHelper.httpDoDiveSearchBy(keyword: keyword, ecoTrip: nil, complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.trySearch(with: keyword)
                        })
                    }
                })
                return
            }
            if let data = response.data, !data.isEmpty {
                self.results = data
                self.tableView.reloadData()
            }
        })
    }
}
