//
//  Annotation.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/20/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import MapKit

enum LocationType {
    case AnnotationDefault
    case Bar
    case Casino
    case SportsStadium
}

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: LocationType
    var venue: Venue
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: LocationType, venue: Venue) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.venue = venue
    }
    
}