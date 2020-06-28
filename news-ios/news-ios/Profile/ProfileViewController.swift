//
//  ProfileViewController.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var streakNumber: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var articlesHistory: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userLabel.text = AppGlobalState.username
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userLabel.text = AppGlobalState.username
        print(AppGlobalState.username)
        self.fetchUserHistory()
    }
    
    func fetchUserHistory() {
        API.getArticlesFeed(type: "history", self.setArticlesHistory)
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = self.articlesHistory[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HIstoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.setCell(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.articlesHistory[indexPath.row].url
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.articlesHistory.count
    }
    
    func setArticlesHistory(_ articlesHistory: [Article]) {
        self.articlesHistory = articlesHistory
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }
}
