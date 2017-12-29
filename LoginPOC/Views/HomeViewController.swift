//
//  HomeViewController.swift
//  LoginPOC
//
//  Created by Rigil on 06/10/1939 Saka.
//  Copyright © 1939 Saka E-SaarTechy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var baseNameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func displayValuesFromKeychain(_ sender: UIButton) {
        let username = KeyChainManager.shared.getUserName()
        let password = KeyChainManager.shared.getPassword()
        let token = KeyChainManager.shared.getToken()
        debugPrint(username)
        debugPrint(password)
        debugPrint(token)
    }
    
    @IBAction func displayBasesButtonTapped(_ sender: UIButton) {
        APIManager.shared.getAllBasesForTheCurrentUser(completion: {(success, bases, error) in
            
            if success{
                if bases?.count != 0 {
                    debugPrint(bases!)
                }else{
                    // Will display error for no data
                    let alert = UIAlertController(title: "", message: "There are no bases to display", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                // Will display error
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func createNewBaseButtonTapped(_ sender: UIButton) {
        
        if baseNameTextField.text != "" && descriptionTextField.text != nil {
            let parameters:[String:String] = [
                "name" : self.baseNameTextField.text!,
                "description" : self.descriptionTextField.text!
            ]
            APIManager.shared.createNewBaseWithValues(parameters: parameters, completion: { (success, newBase, error) in
                
                if success {
                    debugPrint(newBase!)
                }else{
                    // Will display error
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
