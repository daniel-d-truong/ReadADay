//
//  AlertActions.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation
import UIKit

func displayLoginAlert(controller: UIViewController, completion: @escaping (() -> Void))  {
    // 1.
    var usernameTextField: UITextField?
//    var passwordTextField: UITextField?

    // 2.
    let alertController = UIAlertController(
        title: "Log in",
        message: "Please enter your credentials",
        preferredStyle: .alert)

    // 3.
    let loginAction = UIAlertAction(
    title: "Log in", style: .default) {
        (action) -> Void in

        if let username = usernameTextField?.text {
            print(" Username = \(username)")
            AppGlobalState.username = username
        } else {
            print("No Username entered")
        }
        
        completion()

//        if let password = passwordTextField?.text {
//            print("Password = \(password)")
//        } else {
//            print("No password entered")
//        }
    }

    // 4.
    alertController.addTextField {
        (txtUsername) -> Void in
        usernameTextField = txtUsername
        usernameTextField!.placeholder = "<Your username here>"
    }

//    alertController.addTextField {
//        (txtPassword) -> Void in
//        passwordTextField = txtPassword
//        passwordTextField?.isSecureTextEntry = true
//        passwordTextField?.placeholder = "<Your password here>"
//    }

    // 5.
    alertController.addAction(loginAction)
    controller.present(alertController, animated: true, completion: nil)
}

func displaySubmitArticle(controller: UIViewController, completion: @escaping (() -> Void))  {
    // 1.
    var articleTextField: UITextField?
//    var passwordTextField: UITextField?

    // 2.
    let alertController = UIAlertController(
        title: "Submit an Article",
        message: "Paste in a URL to share with others.",
        preferredStyle: .alert)
    
    func successCompletion() {
        
        showSuccessAlert(controller: controller, completion: completion)
    }
    
    func failureCompletion() {
        showFailureAlert(controller: controller, completion: completion)
    }

    // 3.
    let articleAction = UIAlertAction(
    title: "Submit", style: .default) {
        (action) -> Void in

        if let articleURL = articleTextField?.text {
            print(" Article URL = \(articleURL)")
            API.submitArticle(articleURL: articleURL, successCompletion, failureCompletion)
        } else {
            print("No Username entered")
        }
    }

    // 4.
    alertController.addTextField {
        (txtUsername) -> Void in
        articleTextField = txtUsername
        articleTextField!.placeholder = "<Your username here>"
    }

    // 5.
    alertController.addAction(articleAction)
    controller.present(alertController, animated: true, completion: nil)
}

func showSuccessAlert(controller: UIViewController, completion: @escaping (() -> Void)) {
    let controllerAlert = UIAlertController(
        title: "Article Submitted",
        message: "Article has been successfully submitted.",
        preferredStyle: .alert)
    
    controllerAlert.addAction(UIAlertAction(title: "Sounds good", style: .default))
    DispatchQueue.main.sync {
        controller.present(controllerAlert, animated: true, completion: completion)
    }
}

func showFailureAlert(controller: UIViewController, completion: @escaping (() -> Void)) {
    let controllerAlert = UIAlertController(
        title: "Article Failed to Submit",
        message: "Article has failed to submit.",
        preferredStyle: .alert)
    
    controllerAlert.addAction(UIAlertAction(title: "Sounds good", style: .default))
    DispatchQueue.main.sync {
        controller.present(controllerAlert, animated: true, completion: completion)
    }
}
