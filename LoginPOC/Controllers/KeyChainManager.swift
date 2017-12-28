//
//  KeyChainManager.swift
//  LoginPOC
//
//  Created by Rigil on 26/12/17.
//  Copyright © 2017 E-SaarTechy. All rights reserved.
//

import UIKit
import KeychainAccess

class KeyChainManager: NSObject {
    
    static let shared = KeyChainManager()
    
    let keychain = Keychain(service: "persistant_login_poc")
    
    // Constant keys
    enum KeyChainConstant {
        static let UserName = "Username"
        static let Password = "Password"
        static let AuthToken = "AuthToken"
    }
    
    //MARK: - Token management
    func getToken() -> String {
        
        let savedToken = keychain[string: KeyChainConstant.AuthToken]
        if (savedToken != nil) {
            return savedToken!
        }else{
            return ""
        }
    }
    
    func saveToken(token: String) -> Void {
        do {
            try keychain.set(token, key: KeyChainConstant.AuthToken)
        }
        catch let error {
            debugPrint(error)
        }
    }
    
    //MARK: - Get Username from keychain
    func getUserName() -> String {
        
        let savedUsername = keychain[string: KeyChainConstant.UserName]
        if (savedUsername != nil) {
            return savedUsername!
        }else{
            return ""
        }
    }
    
    //Mark:- Get Password from keychain
    func getPassword() -> String {
        let savedPassword = keychain[string: KeyChainConstant.Password]
        if (savedPassword != nil) {
            return savedPassword!
        }else{
            return ""
        }
    }
    
    //MARK: - Save username, password to keychain
    func saveCredentials(username:String, password:String) -> Void {
        do {
            try keychain.set(username, key: KeyChainConstant.UserName)
        }
        catch let error {
            debugPrint(error)
        }
        do {
            try keychain.set(password, key: KeyChainConstant.Password)
        }
        catch let error {
            debugPrint(error)
        }
    }
    
    //MARK:- Remove UserName,Password, Auth Token from keychain
    
    func removeKeyChainSavedCredentials() -> Void {
        
        do {
            try keychain.remove(KeyChainConstant.UserName)
            try keychain.remove(KeyChainConstant.Password)
            try keychain.remove(KeyChainConstant.AuthToken)
            
        } catch let error {
            print("error: \(error)")
        }
    }
}
