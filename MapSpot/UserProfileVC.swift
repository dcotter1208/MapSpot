//
//  UserProfileVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 3/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOutButtonPressed(sender: AnyObject) {
        
        USER_REF.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }

    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }

}
