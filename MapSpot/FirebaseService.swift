//
//  FirebaseService.swift
//  MapSpot
//
//  Created by Donovan Cotter on 3/18/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://mapspotapp.firebaseio.com"

let FIREBASE_REF = Firebase(url: BASE_URL)

let USER_REF = Firebase(url: "\(BASE_URL)/users")

//Once there is a current user we can start using this variable. We get the unique identifier (uid) for that user from our NSUserDefaults. We then ask our Firebase database to get that user on the server and then return it and then we will store it in the variable CURRENT_USER.
var CURRENT_USER: Firebase {
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    
    return currentUser
}

func createNewAccount(uid: String, user: Dictionary<String, String>) {

    USER_REF.childByAppendingPath(uid).setValue(user)
}


