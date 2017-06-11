//
//  SignInVC.swift
//  DSSocialNetwork
//
//  Created by Zack Falgout on 6/7/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let result = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("ZACK: Performing segue to go back to the feed with identifier of goToFeed and with the result of \(result)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookButtonTapped(_ sender: RoundButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("****ZACK: Unable to authenticate with Facebook! \(error)")
            } else if result?.isCancelled == true {
                print("ZACK: User cancelled Facebook authentication")
            } else {
                print("ZACK: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    func firebaseAuthenticate(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("ZACK: Unable to authenticate with Firebase!  \(error)")
                
            } else {
                print("ZACK: Successfully authenticated with Firebase")
                if let user = user {
                    //let _: Bool = KeychainWrapper.standard.set((user.uid), forKey: KEY_UID)
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }

    @IBAction func signInTapped(_ sender: FancyButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    //We've signed the user in.
                    print("ZACK: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, email) in
                        if error != nil {
                            print("ZACK: Unable to authenticate with Firebase using email.  \(error)")
                            
                        } else {
                            print("ZACK: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        //Save the user to the database.
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ZACK: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}




































