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
    
    // Two Types: "feed" and "history"
    func getArticlesFeed(type: String, _ completion: @escaping ((_ articlesList: [Article]) -> Void)) {
        var url: URL!
        if type == "feed" {
            url = URL(string: "\(backendURL)/articles")!
        } else if type == "history" {
            url = URL(string: "\(backendURL)/users/\(AppGlobalState.username!)/readArticles")!
        }
        
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
    
    func submitArticle(articleURL: String, _ successCompletion: @escaping (() -> Void), _ failureCompletion: @escaping (() -> Void)) {
        
        // TODO: Put logic down
        successCompletion()
    }
}

let API = APIFunctions()
