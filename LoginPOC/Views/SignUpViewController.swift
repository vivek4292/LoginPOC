//
//  SignUpViewController.swift
//  LoginPOC
//
//  Created by Rigil on 26/12/17.
//  Copyright © 2017 E-SaarTechy. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {
    
    // IBOutlets of the text fields
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Register action
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.validateRequiredTextFields() {
            
            // Create parameters dictionary with user details
            let parameters:[String: String] = [
                "firstName": self.firstNameTextField.text!,
                "lastName": self.lastNameTextField.text!,
                "email": self.emailTextField.text!,
                "password": self.passwordTextField.text!,
                "username": self.userNameTextField.text!
            ]
            
            APIManager.shared.createUserWithValues(parameters: parameters, completion: { (success, error) in
                
                let alert = UIAlertController()
                if success {
                    // Will move to home screen
                    KeyChainManager.shared.saveCredentials(username:self.emailTextField.text!, password:self.passwordTextField.text!)
                    
                    alert.title = "Success"
                    alert.message = "Register successfully. "
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: self.gotoHomeViewController)
                }else{
                    // Will display error
                    alert.title = "Error"
                    alert.message = error
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            // Will display error for missing fields
            let alert = UIAlertController(title: "Missing Fields", message: "All fields are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Validate all the required fields
    func validateRequiredTextFields() -> Bool {
        
        if self.firstNameTextField.text == "" {
            return false
        }else
            if self.lastNameTextField.text == ""{
                return false
            }else
                if self.userNameTextField.text == "" {
                    return false
                }else
                    if self.passwordTextField.text == "" {
                        return false
                    }else
                        if self.emailTextField.text == "" {
                            return false
                        }else{
                            return true
        }
    }
    
    // Switch to the Home screen
    func gotoHomeViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController_id") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }

}
