//
//  Annotation.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/20/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import MapKit

class Annotation: MKPointAnnotation {
    let pinImage: String?
    
    init(pinImage: String?) {
        self.pinImage = pinImage
        
        super.init()
    }
}