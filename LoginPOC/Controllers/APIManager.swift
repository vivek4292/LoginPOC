//
//  APIManager.swift
//  LoginPOC
//
//  Created by Rigil on 22/12/17.
//  Copyright © 2017 E-SaarTechy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



enum RequestType: String {
    case getToken = "v1/token"
    case createUser = "v1/users"
    case requestBases = "v1/bases"
}

class APIManager: NSObject {
    
    static let shared = APIManager()
    let baseUrl = "http://206.205.101.39:8080/api/"
    
    var requestingNewToken = false
    
    //  Accept username & password and return token
    func doLoginFor(username: String, password: String, completion:@escaping (_ success: Bool, _ error: String?) -> Void ) {
        
        APIManager.shared.requestTokenFor(username: username, password: password, completion: {(success, token, error) in
            
            if success {
                completion(true, nil)
            }else{
                completion(false, error)
            }
        })
        
    }
    
    // Will take username and password as argument and provide security token
    func requestTokenFor(username: String, password: String, completion: @escaping(_ success: Bool, _ token: String, _ error: String?) -> Void){
        
        if username != "" && password != ""  {
            
            let fullUrl = baseUrl + RequestType.getToken.rawValue
            let loginString = "\(username):\(password)"
            let loginData = loginString.data(using: .utf8)
            guard let base64LoginString = loginData?.base64EncodedString(options: .lineLength64Characters) else { return }
            
            let headers = [
                "Authorization" : "Basic \(base64LoginString)"
            ]
            
            Alamofire.request(fullUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                debugPrint("AlamofireStarter - requestToken response: \(response)")
                
                if response.result.isSuccess && response.result.value != nil {
                    
                    let statusCode = response.response!.statusCode
                    
                    if statusCode == 200 {
                        let json = JSON(response.result.value! as Any)
                        if let accessToken = json["token"].string {
                            KeyChainManager.shared.saveToken(token: accessToken)
                            completion(true, accessToken, nil)
                        }
                    } else {
                        completion(false, "", "Invalid username or password.")
                    }
                } else {
                    if let code = response.response?.statusCode {
                        if code == -10001 {
                            completion(false, "", "Request timed out.")
                            return
                        }
                    }
                    completion(false, "", "The Internet connection appears to be offline.")
                }
            })
        }
    }
    
    // Will take new user details in parameters and create new user id
    func createUserWithValues(parameters: [String:String],completion:@escaping(_ success: Bool, _ error: String?) -> Void ){
        
        let fullUrl = baseUrl + RequestType.createUser.rawValue
        
        Alamofire.request(fullUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            
            if response.result.isSuccess && response.result.value != nil {
                let statusCode = response.response?.statusCode
                debugPrint(String(describing: statusCode))
                if statusCode == 201 {
                    APIManager.shared.requestTokenFor(username: parameters["username"]!, password: parameters["password"]!, completion: { (tokenSuccess, token, error) in
                        if tokenSuccess {
                            completion(true, nil)
                        }else{
                            completion(false, error)
                        }
                    })
                }else{
                    completion(false, "Invalid input details.")
                }
            }else{
                if let code = response.response?.statusCode {
                    if code == -10001 {
                        completion(false, "Request timed out.")
                        return
                    }
                }
                completion(false, "The Internet connection appears to be offline.")
            }
        })
    }
    
    func fetchAllBasesForTheCurrentUser(completion:@escaping(_ success: Bool,_ bases: [[String:Any]]?,_ error: String?) -> Void){
        
        let savedToken = KeyChainManager.shared.getToken()
        
        if savedToken == "" {
            // When no saved token is found try to retrieve token from existing username & password stored in keychain
            APIManager.shared.retrieveNewTokenForExistingUsernameAndPassword(completion: { (success, newToken, error) in
                
                if success {
                    APIManager.shared.fetchAllBasesForTheCurrentUser(completion:{(success, bases, error ) in
                        completion(success, bases, error)
                    })
                }else{
                    // Prompt to login again
                }
            })
            
        } else {
            //if token is available, try to make api call; if that fails and it's due to status code "401/403 Unauthorized"; try to get a new token using the saved "Username" and "Password"; if that doesnt work make user login again.
            
            let bearer = "Bearer \(savedToken)"
            
            let header = [
                "Authorization": bearer
            ]
            
            let fullURL = baseUrl + RequestType.requestBases.rawValue
            
            //Make a request for the bases for current user
            
            Alamofire.request(fullURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { response in
                
                if response.response != nil {
                    let statusCode = response.response!.statusCode
                    if statusCode == 200 {
                        if response.result.value != nil && response.result .isSuccess  {
                            let json = JSON(response.result.value as Any)
                            let bases = json["bases"].arrayObject as! [[String:Any]]
                            completion(true, bases,nil)
                        } else {
                            completion(false, nil, "No data is available")
                        }
                    }else if statusCode == 401 || statusCode == 403 {
                        
                        if self.requestingNewToken == false {
                            
                            //request a new token on the first failed attempt with 401
                            
                            let savedUsername = KeyChainManager.shared.getUserName()
                            let savedPassword = KeyChainManager.shared.getPassword()
                            
                            APIManager.shared.requestTokenFor(username: savedUsername, password: savedPassword, completion:{ (success, token, errorMessage) in
                                
                                if success {
                                    APIManager.shared.fetchAllBasesForTheCurrentUser(completion:{(success, bases, error ) in
                                        completion(success, bases, error)
                                    })
                                }else{
                                    self.requestingNewToken = true
                                    // Prompt to login again
                                }
                            })
                        }
                    } else {
                        completion(false, nil,"Autherization failed. ")
                    }
                } else {
                    completion(false, nil , "The Internet connection appears to be offline." )
                }
            })
        }
    }
    
    
    func createNewBaseWithValues(parameters:[String:String], completion:@escaping(_ success: Bool,_ base: [String:Any]?,_ error: String?) -> Void){
        
        let savedToken = KeyChainManager.shared.getToken()
        
        if savedToken == "" {
            // When no saved token is found try to retrieve token from existing username & password stored in keychain
            APIManager.shared.retrieveNewTokenForExistingUsernameAndPassword(completion: { (success, newToken, error) in
                
                if success {
                    APIManager.shared.createNewBaseWithValues(parameters: parameters, completion: {(success, base, error ) in
                        completion(success, base, error)
                    })
                }else{
                    // Prompt to login again
                }
            })
        } else {
            //if token is available, try to make api call; if that fails and it's due to status code "401/403 Unauthorized"; try to get a new token using the saved "Username" and "Password"; if that doesnt work make user login again.
            
            let bearer = "Bearer \(savedToken)"
            
            let header = [
                "Authorization": bearer
            ]
            
            let fullURL = baseUrl + RequestType.requestBases.rawValue
            
            //Make a request for the bases for current user
            
            Alamofire.request(fullURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { response in
                
                if response.response != nil {
                    let statusCode = response.response!.statusCode
                    if statusCode == 201 {
                        if response.result.value != nil && response.result .isSuccess  {
                            let json = JSON(response.result.value as Any)
                            let base = json.dictionaryObject! as [String:Any]
                            completion(true, base, nil)
                        } else {
                            completion(false, nil, "No data is available")
                        }
                    }else if statusCode == 401 || statusCode == 403 {
                        
                        if self.requestingNewToken == false {
                            
                            //request a new token on the first failed attempt with 401
                            let savedUsername = KeyChainManager.shared.getUserName()
                            let savedPassword = KeyChainManager.shared.getPassword()
                            APIManager.shared.requestTokenFor(username: savedUsername, password: savedPassword, completion:{ (success, token, errorMessage) in
                                
                                if success {
                                    APIManager.shared.createNewBaseWithValues(parameters: parameters, completion: {(success, base, error ) in
                                        completion(success, base, error)
                                    })
                                }else{
                                    // Prompt to login again
                                }
                            })
                        }
                    } else {
                        completion(false, nil,"Autherization failed. ")
                    }
                } else {
                    completion(false, nil , "The Internet connection appears to be offline." )
                }
            })
        }
    }

    // Will generate new security token when existing token get expire
    func retrieveNewTokenForExistingUsernameAndPassword(completion:@escaping(_ success: Bool,_ token: String,_ error: String?) -> Void){
        //Try to get new one using the saved "Username" and "Password"; if that doesnt work make user login again.
        
        let sharedKeychainManager = KeyChainManager.shared
        let savedUsername = "\(sharedKeychainManager.getUserName())"
        let savedPassword = "\(sharedKeychainManager.getPassword())"
        
        APIManager.shared.requestTokenFor(username: savedUsername, password: savedPassword, completion: {(success, newToken, error) in
            
            if success {
                completion(true, newToken, nil)
            } else {
                completion(false, "", error)
            }
        })
    }
}
