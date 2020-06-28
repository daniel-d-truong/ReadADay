//
//  FeedTableViewCell.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleTopic: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var categoryBG: UIView!
    
    var article: Article!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(article: Article) {
        articleImage.loadURL(url: URL(string: article.imageSrc)!)
        articleTitle.text = article.title
        articleTopic.text = article.category
        articleDate.text = article.date
        
//        self.backgroundColor = GlobalColors[article.category] ?? UIColor.white
        articleTopic.backgroundColor = GlobalColors[article.category] ?? UIColor.white
        articleTopic.layer.cornerRadius = 15
        articleTopic.layer.masksToBounds = true
    }

}
