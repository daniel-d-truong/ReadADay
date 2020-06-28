//
//  FeedTableViewController.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit
import CoreGraphics

class FeedTableViewController: UITableViewController {
    
    var articlesList: [Article] = []

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.fetchFromBackend()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.articlesList.count*2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTableCell")
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableCell", for: indexPath) as! FeedTableViewCell
        
        // Set cell spacing
        cell.contentView.backgroundColor = UIColor.clear

        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 100))

        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2

        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        cell.setCell(article: self.articlesList[indexPath.row/2])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articlesList[indexPath.row/2]
        let urlString = article.url
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
        
        // Give user credit for reading this article
        API.postArticleUserRead(id: article.id, successCompletion: {}, failureCompletion: {})
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row % 2 == 1) {
            return 20
        }
        return 120
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
                API.getArticlesFeed(type: "feed", self.setArticlesList)
            }
            
            print(self.articlesList.count)
        }
        
        fetch()
    }
    
    func setArticlesList(_ articlesList: [Article]) {
        self.articlesList = articlesList
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }

    /**
     * Login Section
     */
    @IBAction func loginOnClick(_ sender: Any) {
        displayLoginAlert(controller: self, completion: fetchFromBackend)
    }
    
    // Add Section
    @IBAction func addOnClick(_ sender: Any) {
        displaySubmitArticle(controller: self, completion: fetchFromBackend)
    }
}
