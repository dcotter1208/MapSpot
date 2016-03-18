//
//  SignUpVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 3/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountPressed(sender: AnyObject) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username != "" && email != "" && password != "" {
            FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, result) -> Void in
                
                if error == nil {
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                        if error == nil {
                            
                            let user = ["provider": authData.provider!, "email": email!, "username": username!]
                            
                            createNewAccount(authData.uid, user: user)
                            
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            self.performSegueWithIdentifier("createAccountSegue", sender: self)
                        } else {
                            print(error)
                        }
                    })
                } else {
                    print(error)
                }
            })
        } else {
            print("Please fill in all required fields.")
        }
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


}
