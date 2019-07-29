//
//  LoginVC.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-21.
//  Copyright © 2019 Wael. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController , UITextFieldDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var LoginButton: UIButton!
    
    
    @IBAction func Loginclicked(_ sender: Any) {
         updateUI(processing: true)
        
        let username = Username.text
        let password = Password.text
        
        if (username!.isEmpty) || (password!.isEmpty) {
            
            let requiredInfoAlert = UIAlertController (title: "Fill the required fields", message: "Please fill both the email and password", preferredStyle: .alert)
            
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            updateUI(processing: false)
            APIudacity.login(username, password){(loginSuccess, key, error) in
                
                DispatchQueue.main.async {
                    
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                    
                    if !loginSuccess {
                        let loginAlert = UIAlertController(title: "Erorr logging in", message: "incorrect email or password", preferredStyle: .alert )
                        
                        loginAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(loginAlert, animated: true, completion: nil)
                    } else {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabbarCont") as! UITabBarController
                        self.present(controller, animated: true)
       
                        print ("the key is \(key)")
                    }
                }}
        }
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
// Activity Indicator
    func updateUI(processing: Bool) {
        DispatchQueue.main.async {
            self.Username.isUserInteractionEnabled = !processing
            self.Password.isUserInteractionEnabled = !processing
            self.LoginButton.isEnabled = !processing
            self.ActivityIndicator.isHidden = !processing
            if processing {
                self.LoginButton.setTitle("", for: .normal)
            } else {
                self.LoginButton.setTitle("Login", for: .normal)
            }
        }
    }
    
    
    
}
        
