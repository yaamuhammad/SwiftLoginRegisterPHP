//
//  RegisterPageViewController.swift
//  LoginRegisterSimple
//
//  Created by Imam Asari on 4/20/18.
//  Copyright © 2018 Imam Asari. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var _emailTP: UITextField!
    @IBOutlet weak var _passwordTP: UITextField!
    @IBOutlet weak var _confirmPasswordTP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func registerButtonTapped(_ sender: Any) {
        let email = _emailTP.text!
        let password = _passwordTP.text!
        let confirmPassword = _confirmPasswordTP.text!
        
        // check form emtpy field
//        if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//            displayAlertMessage(userMessage: "All fields are required2")
//           return
//        }
//        
        if (password != confirmPassword) {
            displayAlertMessage(userMessage: "password do not match2")
            return
        }
        
        // store data
        let params: Dictionary<String, Any> = [
            "email": email,
            "password": password
        ]
        
        Just.post("http://localhost/~imam/swift_web_register/userRegister.php", json: params) { response in
            print (response.statusCode!)
            guard response.statusCode == 200 else {
                let data = JSON(response.json!)
                self.displayAlertMessage(userMessage: data["message"].stringValue)
                return;
            }
            let data = JSON(response.json!)
            
            // di tampilkan di mainthread
            DispatchQueue.main.async {
                let myAlert = UIAlertController(title: "Alert", message: data["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    action in self.dismiss(animated: true, completion:nil)
                }
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
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
    
    @IBAction func closeRegister(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
