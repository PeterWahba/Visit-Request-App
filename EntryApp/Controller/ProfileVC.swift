//
//  ProfileVC.swift
//  EntryApp
//
//  Created by Peter Mounir on 3/21/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func logoutBtn(_ sender: Any) {
        logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    func logout () {
            defaults.set(false, forKey: "isLoggedIn")
            defaults.set(nil, forKey: "userToken")
            
            Switcher.updateRootVC()
        
    }
    
    //    MARK: - Networking
    
    func getUserData()  {
        
        let edit_url = "http://localhost:5000/api/user/me/"
        getRequestsData(url: edit_url)
  
    }
    
    func getRequestsData (url: String) {
        let HTTPHeaders : [String:String] = ["x-auth-token": defaults.value(forKey: "userToken") as! String]
        Alamofire.request(url, method: .get,headers: HTTPHeaders).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !, Got the user data")
                let requestJSON : JSON = JSON(response.result.value!)
                print(requestJSON)
                self.updateUI(json: requestJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
   func updateUI (json : JSON) {
    
        print("user data \(json["user"]["name"])")
    
        nameLabel.text = json["user"]["name"].stringValue
        emailLabel.text = json["user"]["email"].stringValue

    }

}
