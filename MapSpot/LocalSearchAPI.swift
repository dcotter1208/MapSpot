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
                    print(venue.name)
                    print(venue.address)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.venueArray.append(venue)
                        self.createAnnotation(self.mapView)
                        print(self.venueArray.count)
                    })
                }
            }
        }
    }
    
    func createAnnotation(map:MKMapView) {
        for venue in venueArray {
            let annotation = MapAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.lat), longitude: Double(venue.long)))
                map.addAnnotation(annotation)
        }
    }

    
    
}





