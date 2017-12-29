//
//  LoginViewController.swift
//  LoginPOC
//
//  Created by Rigil on 22/12/17.
//  Copyright © 2017 E-SaarTechy. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passeordTextField: UITextField!
    
    var alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Login button action
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)

        if  validateLoginCredentials() {
            
            let username = usernameTextField.text!
            let password = passeordTextField.text!
            
            APIManager.shared.doLoginFor(username: username, password: password, completion:{ (success, errorMessage) in
                
                print("LoginViewController - login \(success)")
                if success {
                    //Save credentials here and not in Alamofire or if token is successful and getting initial objects is not, then user will be logged in if they restart the app
                    
                    KeyChainManager.shared.saveCredentials(username: username, password: password)
                    self.gotoHomeViewController()
                    
                } else {
                    //Clear saved credentials
                    KeyChainManager.shared.saveCredentials(username: "", password: "")
                    KeyChainManager.shared.saveToken(token: "")
                    
                    //Show alert to user
                    if let message = errorMessage {
                        self.alertController.message = message
                    } else {
                        self.alertController.message = ""
                    }
                    self.alertController.title = "Error"
                    self.alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(self.alertController, animated: true, completion: {
                    })
                }
            })
        } else {
            self.alertController.title = "Missing Fields"
            self.alertController.message = "Please Enter All Credentials"
            self.alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(self.alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func testAPIButtonTapped(_ sender: UIButton){
//        let tableId = "5a448f899d03001e48c57856""
        let baseId = "5a4491859d03001e48c57857"
        let parameters = [
            "name": "Testing_Table"
        ]
//        APIManager.shared.getDataForTableWith(id: tableId, completion: {(success, tableData, error) in
//            if success {
//                debugPrint(tableData)
//            }else{
//                debugPrint(error)
//            }
//
//        })
        
        APIManager.shared.createNewTableForTheBaseWith(baseId: baseId, parameters: parameters, completion: {(success, newTable, error) in
            if success {
                debugPrint(newTable!)
            }else{
                debugPrint(error ?? "Error")
            }
        })
    }
    
    
    // Validate the required text fields
    func validateLoginCredentials() -> Bool {
        if self.usernameTextField.text! == "" || self.usernameTextField == nil {
            return false
        }else
            if self.passeordTextField.text! == "" || self.passeordTextField == nil {
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

