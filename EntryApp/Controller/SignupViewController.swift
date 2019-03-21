//
//  SignupViewController.swift
//  EntryApp
//
//  Created by Peter Mounir on 3/7/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupViewController: UIViewController {

    let defaults = UserDefaults.standard

    
    @IBAction func signupBtnPressed(_ sender: Any) {
        userRegister()
    }
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //    MARK: - Networking
    
    func userRegister()  {
        if let userEmail = userEmailTextField.text, let userPassword = userPasswordTextField.text, let userName = userNameTextField.text {
            
            let param : [String : String] = ["name": userName , "email": userEmail ,"password" : userPassword ]
            let edit_url = "http://localhost:5000/api/user/register/"
            serverUserRegister(url: edit_url, parametersss: param)
        }
    }
    
    func serverUserRegister (url: String, parametersss: [String : String]) {
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
                                print("userToken : \(userToken)")
                                print(responseObject)
                self.defaults.set(userToken.stringValue, forKey: "userToken")
                self.defaults.set(true, forKey: "isLoggedIn")
                Switcher.updateRootVC()
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
    
    //    MARK: - Present alart
    
    func presentAlart(with value: String) {
        let alert = UIAlertController(title: "Signup Error", message: value, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            //  what will happen once the user clicks the Add Category button on our UIAlert
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
