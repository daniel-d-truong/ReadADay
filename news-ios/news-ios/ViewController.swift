//
//  ViewController.swift
//  news-ios
//
//  Created by Daniel Truong on 6/27/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonOnClick(_ sender: Any) {
        print("clicked")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! MainTabBarController
        print(vc)
        print(self.navigationController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

