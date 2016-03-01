//
//  LocalSearchAPI.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/20/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import Foundation
import MapKit

enum SearchTerm: String {
    case Default = "Fun"
    case Bar = "Bar"
    case DanceClub = "Dance Clubs"
    case DiveBar = "Dive Bar"
    case Drinks = "Drinks"
    case SportsBar = "Sports Bar"
    case Casino = "Casino"
}

class LocalSearchAPI {
    
    var venueArray: [Venue]
    var mapView: MKMapView
    
    init(venueArray: [Venue], mapView: MKMapView) {
        self.venueArray = venueArray
        self.mapView = mapView
    }
    
    func localSearch(region: MKCoordinateRegion, searchQuery: SearchTerm) {

        let searchRequest = MKLocalSearchRequest()
        let searchTerm = searchQuery.rawValue
        searchRequest.naturalLanguageQuery = searchTerm
        searchRequest.region = region
        
//        print("Search Term: \(searchTerm)")
//        
        let search = MKLocalSearch(request: searchRequest)
        
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
                    
                    self.decideVenueType(searchQuery, venue: venue)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.venueArray.append(venue)
                        self.createAnnotation(self.mapView)
                    })
                }
            }
        }
    }
    
    func createAnnotation(map:MKMapView) {
        
        for venue in venueArray {
            
            let coordinate = CLLocationCoordinate2DMake(venue.lat, venue.long)
            let locationAnnotation = LocationAnnotation(coordinate: coordinate, title: venue.name, subtitle: venue.address, type: venue.locationType!)
            locationAnnotation.title = venue.name
            locationAnnotation.subtitle = venue.address
            locationAnnotation.coordinate = CLLocationCoordinate2DMake(venue.lat, venue.long)
            map.addAnnotation(locationAnnotation)
            
        }
    }
    
    func decideVenueType(queryType: SearchTerm, venue: Venue) {
                
        switch queryType {
        case .Bar, .DanceClub, .DiveBar, .Drinks, .SportsBar:
            venue.locationType = LocationType.Bar
//            print("Venue Type is a Bar: \(venue.locationType)")
        case .Casino:
            venue.locationType = LocationType.Casino
            print("Venue Type is a Casino: \(venue.locationType)")
        default:
            venue.locationType = LocationType.AnnotationDefault
//            print("Fun")
        }
    }



}

