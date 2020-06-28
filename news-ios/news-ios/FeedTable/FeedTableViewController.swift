//
//  FeedTableViewController.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var articlesList: [Article] = []

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchFromBackend()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.articlesList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableCell", for: indexPath) as! FeedTableViewCell
        tableCell.setCell(article: self.articlesList[indexPath.row])
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.articlesList[indexPath.row].url
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func fetchFromBackend() {
        
        // Logic to fetch from backend
        func fetch() {
            print("called fetch")
            
            if (AppGlobalState.username == nil) {
                displayLoginAlert(controller: self, completion: fetch)
            }
            
            else {
                API.getArticlesFeed(self.setArticlesList)
            }
            
            print(self.articlesList.count)
        }
        
        fetch()
    }
    
    func setArticlesList(_ articlesList: [Article]) {
        self.articlesList = articlesList
        self.tableView.reloadData()
    }

    /**
     * Login Section
     */
    @IBAction func loginOnClick(_ sender: Any) {
        displayLoginAlert(controller: self, completion: fetchFromBackend)
    }
    
    // Add Section
    @IBAction func addOnClick(_ sender: Any) {
        displaySubmitArticle(controller: self, completion: {})
    }
    
    
}
