
//
//  MapVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/17/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var annotationButtons: [UIButton]!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var mapStyleToolbarButton: UIBarButtonItem!

    private var locationManager:CLLocationManager?
    private let distanceSpan:Double = 500
    private var region = MKCoordinateRegion()
    private var venueArray = [Venue]()
    private var selectedAnnotation: LocationAnnotation?
    private var annotationInSelectedState: Bool?
    
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
        
        let annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: "Location")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        return annotationView

    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.performSegueWithIdentifier("mapToDetailVC", sender: self)
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

            selectedAnnotation = view.annotation as? LocationAnnotation

        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        

    }

    override func viewDidLayoutSubviews() {
        
        if mapView.mapType == .Standard {
            changeButtonColorToBlack()
        }
        
        for button in annotationButtons {
            button.layer.cornerRadius = button.frame.size.width/2
        }
                
    }
    
    func changeButtonColorToBlack() {
        
        for button in self.annotationButtons {
            button.backgroundColor = UIColor.blackColor()
            button.tintColor = UIColor.whiteColor()
        }
        
    }
    
    func changeButtonColorToWhite() {
        
        for button in self.annotationButtons {
            button.backgroundColor = UIColor.whiteColor()
            button.tintColor = UIColor.blackColor()
        }
        
    }
        
    @IBAction func findBars(sender: AnyObject) {
        
        let barSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        barSearch.localSearch(region, searchQueries: [.Bar, .DanceClub, .DiveBar, .Drinks, .SportsBar, .Brewery])

    }
    
    @IBAction func findClubs(sender: AnyObject) {
        
        let danceClubSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        danceClubSearch.localSearch(region, searchQueries: [.DanceClub])

    }
    
    @IBAction func findDiveBars(sender: AnyObject) {

        let diveBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        diveBarSearch.localSearch(region, searchQueries : [.DiveBar])
    }
    
    @IBAction func findSportsBars(sender: AnyObject) {

        let sportsBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        sportsBarSearch.localSearch(region, searchQueries: [.SportsBar])
    }

    @IBAction func findSportsStadiums(sender: AnyObject) {
        
        let sportsStadiumsSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        sportsStadiumsSearch.localSearch(region, searchQueries: [.Stadium, .Arena])
        
    }
    
    @IBAction func findAllFun(sender: AnyObject) {
        
        let findAllFunSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        findAllFunSearch.localSearch(region, searchQueries: [.Stadium, .Arena, .Casino, .ConcertVenue, .Theatre])
        
    }
    
    @IBAction func findCasinos(sender: AnyObject) {
        
        let casinoSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        casinoSearch.localSearch(region, searchQueries: [.Casino])
        
    }
    
    @IBAction func findMusicVenue(sender: AnyObject) {
        
        let musicVenueSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        musicVenueSearch.localSearch(region, searchQueries: [.ConcertVenue, .Theatre])
        
    }
    
    
    @IBAction func mapViewStylePressed(sender: AnyObject) {
        
        if mapView.mapType == .SatelliteFlyover {
            mapView.mapType = .Standard
            changeButtonColorToBlack()
            mapStyleToolbarButton.title = "3D"
            
        } else if mapView.mapType == .Standard {
            mapView.mapType = .SatelliteFlyover
            mapView.camera.pitch = 45
            changeButtonColorToWhite()
            mapStyleToolbarButton.title = "Map"
        }
        
    }
    
    @IBAction func showOrHideToolbarAndNavBar(sender: AnyObject) {

            if toolbar.hidden == false {
                toolbar.hidden = true
                self.navigationController?.navigationBarHidden = true
            } else {
                toolbar.hidden = false
                self.navigationController?.navigationBarHidden = false
        }
        


        
    }
    
    
    @IBAction func showMenuItems(sender: AnyObject) {
        
        for button in annotationButtons {
            if button.hidden == false {
                button.hidden = true
            } else {
                button.hidden = false
            }
        }
    }
    
    
}


