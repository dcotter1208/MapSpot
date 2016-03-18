//
//  LoginVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 3/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                
                if error != nil {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                } else {
                    print(error)
                }
                
            })
        } else {
            print("PLESAE CHECK USERNAME & PASSWORD")
        }
    }


}
