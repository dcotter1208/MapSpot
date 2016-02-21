//
//  MapVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/17/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import MapKit


/*

Foursquare multiple category search:

/v2/venues/search?categoryId=4bf58dd8d48988d121941735,4bf58dd8d48988d11f941735,4bf58dd8d48988d1d8941735,4bf58dd8d48988d1e9931735,4bf58dd8d48988d1e7931735&ll=47.6097,-122.3331&radius=10000&intent=browse&v=20120801

    to increase limit:

    &limit=50

*/


class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager:CLLocationManager?
    private let distanceSpan:Double = 500
    private var region = MKCoordinateRegion()
    private var venueArray = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let mapView = self.mapView {
            mapView.delegate = self
            mapView.showsPointsOfInterest = false
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50 // Don't send location updates with a distance smaller than 50 meters between them
            locationManager!.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)

            mapView.setRegion(region, animated: true)
            

            

            }
        }
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //First, check if the annotation isn’t accidentally the user blip.
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        
        pin?.canShowCallout = true
        
        return pin
    }
    
    @IBAction func switchToSatelliteView(sender: AnyObject) {
        mapView.mapType = .Hybrid
        mapView.pitchEnabled = true
        mapView.camera.pitch = 40

        
    }
    @IBAction func findBars(sender: AnyObject) {
        
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)

        let barSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        barSearch.localSearch(region, queryTerm: "Bar")
        
        let danceClubSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        danceClubSearch.localSearch(region, queryTerm: "Dance Clubs")
        
        let diveBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        diveBarSearch.localSearch(region, queryTerm: "Dive Bar")
        
        let drinksSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        drinksSearch.localSearch(region, queryTerm: "Drinks")
        
        let sportsBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        sportsBarSearch.localSearch(region, queryTerm: "Sports Bar")
        
    }
    
    @IBAction func findCasinos(sender: AnyObject) {
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)

        let casinoSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        casinoSearch.localSearch(region, queryTerm: "Casinos")
        let MGMSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        MGMSearch.localSearch(region, queryTerm: "MGM Grand Detroit")
        
        
    }
    
    
    
}


