//
//  ProfileViewController.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit
import Charts

class ProfileViewController: UIViewController {
    @IBOutlet weak var streakNumber: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var articlesHistory: [Article] = []
    
    var civilRightsDataEntry = PieChartDataEntry(value: 0)
    var sustainabilityDataEntry = PieChartDataEntry(value: 0)
    var healthDataEntry = PieChartDataEntry(value: 0)
    var chartEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userLabel.text = AppGlobalState.username
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userLabel.text = AppGlobalState.username
        func setStreak(_ x: Int) {
            DispatchQueue.main.sync {
                self.streakNumber.text = String(x)
            }
        }
        
        API.getUserInfo(completion: setStreak)
        self.fetchUserHistory()
        
        pieChartView.sizeToFit()
    }
    
    func fetchUserHistory() {
        API.getArticlesFeed(type: "history", self.setArticlesHistory)
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: self.chartEntries as! [ChartDataEntry], label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = Array(GlobalColors.values)
        print(colors)
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChartView.data = chartData
    }
    
    func setUpPieChart() {
        // animate
        pieChartView.animate(xAxisDuration: 2, easingOption: .easeOutBack)
        pieChartView.animate(yAxisDuration: 2, easingOption: .easeOutBack)
        
        civilRightsDataEntry.value = Double(Article.getAllArticlesWith(category: "civil rights", list: self.articlesHistory).count)
        civilRightsDataEntry.label = "Civil Rights"
        
        sustainabilityDataEntry.value = Double(Article.getAllArticlesWith(category: "sustainability", list: self.articlesHistory).count)
        sustainabilityDataEntry.label = "Substainability"
        
        healthDataEntry.value = Double(Article.getAllArticlesWith(category: "health", list: self.articlesHistory).count)
        healthDataEntry.label = "Health"
        
        pieChartView.chartDescription?.text = ""
        chartEntries = [civilRightsDataEntry, sustainabilityDataEntry, healthDataEntry]
        
        updateChartData()
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
            self.setUpPieChart()
        }
    }
}
