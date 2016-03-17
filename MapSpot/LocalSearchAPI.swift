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
    case Brewery = "Brewery"
    case Casino = "Casino"
    case Stadium = "Stadium"
    case Arena = "Arena"
    case ConcertVenue = "Concert Venues"
    case Theatre = "Performing Arts Theatre"
}

class LocalSearchAPI {
    
    var venueArray: [Venue]
    var mapView: MKMapView
    
    init(venueArray: [Venue], mapView: MKMapView) {
        self.venueArray = venueArray
        self.mapView = mapView
    }
    
    func localSearch(region: MKCoordinateRegion, searchQuery: SearchTerm) {
        
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        
        let searchRequest = MKLocalSearchRequest()
        let searchTerm = searchQuery.rawValue
        searchRequest.naturalLanguageQuery = searchTerm
        searchRequest.region = region

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
                    
                    self.decideLocationType(searchQuery, venue: venue)
                    
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
    
    func decideLocationType(queryType: SearchTerm, venue: Venue) {
                
        switch queryType {
        case .Bar, .DanceClub, .DiveBar, .Drinks, .SportsBar, .Brewery:
            venue.locationType = LocationType.Bar
            print("Venue Type is a Bar: \(venue.locationType)")
        case .Casino:
            venue.locationType = LocationType.Casino
            print("Venue Type is a Casino: \(venue.locationType)")
        case .Stadium, .Arena:
            venue.locationType = LocationType.SportsStadium
        default:
            venue.locationType = LocationType.AnnotationDefault
            print("Fun")
        }
    }

    func containsString(string:String)-> Bool {
    
        let venue = Venue()
        
            if venue.name.containsString(string) {
                return true
        }

        return false
    }

}

