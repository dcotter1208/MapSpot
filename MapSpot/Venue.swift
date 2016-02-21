//
//  Venue.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/19/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import MapKit

class Venue {
    var name = ""
    var phoneNumber = ""
    var address = ""
    var website =  NSURL()
    var lat = 0.00
    var long = 0.00
    
    var coordinate:CLLocation {
        return CLLocation(latitude: Double(lat), longitude: Double(long));
    }
}