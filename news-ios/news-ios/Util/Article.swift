//
//  Article.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation

class Article {
    var url: String
    var title: String
    var imageSrc: String
    var category: String
    
    init(url: String, title: String, imageSrc: String, category: String) {
        self.url = url
        self.title = title
        self.imageSrc = imageSrc
        self.category = category
    }
}
