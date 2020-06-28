//
//  API.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation
import SwiftyJSON

let backendURL = "http://localhost:8000";

class APIFunctions {
    
    // Private Init. DO NOT MAKE AN OBJECT FROM THIS
    init() {}
    
    func getArticlesFeed(_ completion: @escaping ((_ articlesList: [Article]) -> Void)) {
//        var articlesList: [Article] = []
        
//        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
//        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
//        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals"))
  
        let url = URL(string: "\(backendURL)/articles")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if error took place
            if let error = error {
                print("Error took place")
                return
            }
                        
            if let response = response as? HTTPURLResponse {
                print("Response HTTP status code: \(response.statusCode)")
            }
                        
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonPod = JSON(json)
                    let mainArray = jsonPod["Articles"]
                    
                    var arr: [Article] = []
                    for dict in mainArray {
                        arr.append(Article(dict.1))
                    }
                    
                    completion(arr)
                }
                
                catch {
                    
                }
            }

        }
        task.resume()
    }
    
    func getArticlesHistory(_ completion: @escaping ((_ articlesList: [Article]) -> Void)) {
        var articlesList: [Article] = []
        
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals", id: "some string"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals", id: "some string"))
        articlesList.append(Article(url: "https://markmanson.net/best-articles", title: "Cat", imageSrc: "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", category: "Animals", id: "some string") )
        
        completion(articlesList)
    }
    
    func submitArticle(articleURL: String, _ successCompletion: @escaping (() -> Void), _ failureCompletion: @escaping (() -> Void)) {
        
        // TODO: Put logic down
        successCompletion()
    }
}

let API = APIFunctions()
