//
//  API.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation
import SwiftyJSON

//let backendURL = "http://localhost:8000";
let backendURL = "https://read-a-day-api.herokuapp.com"

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
        // Prepare URL
        let url = URL(string: "\(backendURL)/articles")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        var dict: [String: String] = [:]
        dict["URL"] = articleURL
        dict["username"] = AppGlobalState.username!
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpBody = jsonData
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                failureCompletion()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Failed: Got status code \(httpResponse.statusCode)")
                    failureCompletion()
                }
            }
         
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                successCompletion()
            } else {
                failureCompletion()
            }
            
        }
        task.resume()
    }
    
    func getUserInfo(user: String = "", completion: @escaping ((Int) -> Void)) {
        var userName = user
        if (userName == "") {
            userName = AppGlobalState.username!
        }
        
        let url = URL(string: "\(backendURL)/users/\(userName)/info")
        
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
                    print(jsonPod)
                    completion(jsonPod["StreakInDays"].int!)
                }
                
                catch {
                    
                }
            }

        }
        task.resume()
    }
    
    func postArticleUserRead(id: Int, successCompletion: @escaping (() -> Void), failureCompletion: @escaping (() -> Void)) {
        // Prepare URL
        let url = URL(string: "\(backendURL)/users/\(AppGlobalState.username!)/readArticles")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        var dict: [String: Int] = [:]
        dict["ID"] = id
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpBody = jsonData
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                failureCompletion()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Failed: Got status code \(httpResponse.statusCode)")
                    failureCompletion()
                }
            }
         
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                print("success")
                successCompletion()
            } else {
                failureCompletion()
            }
            
        }
        task.resume()
    }
}

let API = APIFunctions()
