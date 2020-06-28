//
//  Article.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article {
    var url: String
    var title: String
    var imageSrc: String
    var category: String
    var id: Int
    var date: String
    
    init(url: String, title: String, imageSrc: String, category: String, id: Int, date: String) {
        self.url = url
        self.title = title
        self.imageSrc = imageSrc
        self.category = category
        self.id = id
        self.date = date
    }
    
    convenience init(_ dict: JSON) {
        self.init(url: dict["URL"].string!, title: dict["Title"].string!, imageSrc: dict["ImageURL"].string!, category: dict["Category"].string!, id: dict["ID"].int!, date: dict["Date"].string!)
    }
    
    static func getAllArticlesWith(category: String, list: [Article]) -> [Article] {
        return list.filter { $0.category == category }
    }
}
