//
//  LocationAnnotationView.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/29/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotationView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let locationAnnotation = self.annotation as! LocationAnnotation

        switch (locationAnnotation.type) {
            
        case .Bar:
            image = UIImage(named: "bar")
            print("image is a bar")
        case .Casino:
            image = UIImage(named: "casino")
            print("image is a casino")
        case .SportsStadium:
            image = UIImage(named: "stadium")
        default:
            image = UIImage(named: "pin")
            print("image is a pin")

        }
    }
    
}
