//
//  LocalSearchAPI.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/20/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import MapKit

class LocalSearchAPI {
    
    var venueArray: [Venue]
    var mapView: MKMapView
    
    init(venueArray: [Venue], mapView: MKMapView) {
        self.venueArray = venueArray
        self.mapView = mapView
    }
    
    func localSearch(region: MKCoordinateRegion, queryTerm: String) {
        let requestBar = MKLocalSearchRequest()
        requestBar.naturalLanguageQuery = queryTerm
        requestBar.region = region
        
        let search = MKLocalSearch(request: requestBar)
        
        search.startWithCompletionHandler {
            (response, error) -> Void in
            
            if let mapItems = response?.mapItems {
                for item:MKMapItem in mapItems {
                    
                    let venue = Venue()
                    
                    if let venueName = item.name {
                        venue.name = venueName
                    }
                    
                    if let venuePhoneNumber = item.phoneNumber {
                        venue.phoneNumber = venuePhoneNumber
                    }
                    
                    if let venueAddress = item.placemark.title {
                        venue.address = venueAddress
                    }
                    
                    if let coordinates = item.placemark.location {
                        venue.lat = coordinates.coordinate.latitude
                        venue.long = coordinates.coordinate.longitude
                    }
                    
                    if let venueWebsite = item.url {
                        venue.website = venueWebsite
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.venueArray.append(venue)
                        self.createAnnotation(self.mapView)
                        print("Array Count: \(self.venueArray.count)")
                    })
                }
            }
        }
    }
    
    func createAnnotation(map:MKMapView) {
        
        for venue in venueArray {

                var annotationView = MKPinAnnotationView()
                let annotation = Annotation(pinImage: "Arrow")
                annotation.title = venue.name
                annotation.subtitle = venue.address
                annotation.coordinate = CLLocationCoordinate2DMake(venue.lat, venue.long)
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView.image = UIImage(named: annotation.pinImage!)
                map.addAnnotation(annotationView.annotation!)

        }
    }


}

