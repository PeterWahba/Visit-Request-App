//
//  WelcomeViewController.swift
//  
//
//  Created by Peter Mounir on 3/7/19.
//

import UIKit

class WelcomeViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(defaults.bool(forKey: "isLoggedIn"))
        print(defaults.value(forKey: "userToken") ?? "no token found")
        
        
        if (defaults.bool(forKey: "isLoggedIn")) {
            print("have token ...")
            performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    



}
