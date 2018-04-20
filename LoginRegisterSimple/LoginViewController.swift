//
//  LoginViewController.swift
//  LoginRegisterSimple
//
//  Created by Imam Asari on 4/20/18.
//  Copyright © 2018 Imam Asari. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTP: UITextField!
    @IBOutlet weak var passwordTP: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
//        let storedEmail = UserDefaults.standard.string(forKey: "email")
//        let storedPassword = UserDefaults.standard.string(forKey: "password")
//
//        if (emailTP.text == storedEmail && passwordTP.text == storedPassword) {
//            UserDefaults.standard.set(true, forKey:"isLoggedIn")
//            UserDefaults.standard.synchronize()
//            self.dismiss(animated: true, completion:nil);
//        } else {
//            displayAlertMessage(userMessage: "Incorrect Credentials")
//        }
        
        let params: Dictionary<String, Any> = [
            "email": emailTP.text!,
            "password": passwordTP.text!
        ]
        
        Just.post("http://localhost/~imam/swift_web_register/userLogin.php", json: params) { response in
            print (response.statusCode!)
            guard response.statusCode == 200 else {
                let data = JSON(response.json!)
                self.displayAlertMessage(userMessage: data["message"].stringValue)
                return;
            }
            let data = JSON(response.json!)
            let defaults = UserDefaults.standard
            defaults.set(data["email"].string, forKey:"email")
            defaults.set(true, forKey:"isLoggedIn")
            defaults.synchronize()
            self.dismiss(animated: true, completion:nil);
        }
        
    }
    
    func displayAlertMessage(userMessage:String) {
        DispatchQueue.main.async {
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }

}
