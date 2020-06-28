//
//  API.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation

class APIFunctions {
    // Private Init. DO NOT MAKE AN OBJECT FROM THIS
    init() {}
    
    func getArticlesFeed(_ completion: @escaping ((_ articlesList: [Article]) -> Void)) {
        var articlesList: [Article] = []
        
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        
        completion(articlesList)
    }
    
    func getArticlesHistory(_ completion: @escaping ((_ articlesList: [Article]) -> Void)) {
        var articlesList: [Article] = []
        
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
        
        completion(articlesList)
    }
    
    func submitArticle(articleURL: String, _ successCompletion: @escaping (() -> Void), _ failureCompletion: @escaping (() -> Void)) {
        successCompletion()
    }
}

let API = APIFunctions()
