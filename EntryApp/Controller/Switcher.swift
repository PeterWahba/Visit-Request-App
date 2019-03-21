//
//  Switcher.swift
//  EntryApp
//
//  Created by Peter Mounir on 3/21/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        var rootVC : UIViewController?
        
        print("isLoggedIn : \(isLoggedIn)")
        
        
        if(isLoggedIn == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarVC
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcomevc") as! WelcomeVC
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}
