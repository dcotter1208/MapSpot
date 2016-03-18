//
//  SignUpVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 3/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

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
        
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


}
