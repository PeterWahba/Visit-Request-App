//
//  LoginViewController.swift
//  EntryApp
//
//  Created by Peter Mounir on 3/7/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//Constants

class LoginViewController: UIViewController, UITextFieldDelegate {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBAction func loginBtnPressed(_ sender: Any) {
        userLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(defaults.bool(forKey: "isLoggedIn"))
        print(defaults.value(forKey: "userToken") ?? "no token found")
        

    }
    

    
    
    //    MARK: - Networking
    
    func userLogin()  {
        if let userEmail = userEmailTextField.text, let userPassword = userPasswordTextField.text {
    
            let param : [String : String] = ["email": userEmail ,"password" : userPassword ]
            let edit_url = "http://localhost:5000/api/user/auth/"
            serverUserAuth(url: edit_url, parametersss: param)
        }
        print("Login func ... \(userEmailTextField.text ?? " ")")
    }
    
    func serverUserAuth (url: String, parametersss: [String : String]) {
        Alamofire.request(url, method: .post, parameters: parametersss).responseJSON {
            response in
            
            switch response.result {
            case .failure( _):

                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                    self.defaults.set(false, forKey: "isLoggedIn")
                    self.presentAlart(with: "\(responseString)")
                }
            case .success(let responseObject):
                let requestJSON : JSON = JSON(responseObject)
                let userToken = requestJSON["token"]
//                print("userToken : \(userToken)")
                print("User Data : \(requestJSON)")
                self.defaults.set(userToken.stringValue, forKey: "userToken")
                self.defaults.set(true, forKey: "isLoggedIn")
                self.goToList()
            }
        }
    }
    
    
    //    MARK: Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func goToList()  {
        performSegue(withIdentifier: "fromloginToList", sender: self)

    }
    
    
    //    MARK: - Present alart
    
    func presentAlart(with value: String) {
        let alert = UIAlertController(title: "Login Error", message: value, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            //  what will happen once the user clicks the Add Category button on our UIAlert
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


