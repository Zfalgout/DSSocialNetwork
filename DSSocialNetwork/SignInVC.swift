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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
        //loginButton.center = view.center
        
        //view.addSubview(loginButton)
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
            }
        }
    }


}

