//
//  MapVC.swift
//  MapSpot
//
//  Created by Donovan Cotter on 2/17/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var allBarsButton: UIButton!
    @IBOutlet weak var clubsButton: UIButton!
    @IBOutlet weak var diveBarButton: UIButton!
    @IBOutlet weak var sportsBarButton: UIButton!
    @IBOutlet weak var casinosButton: UIButton!
    @IBOutlet var annotationButtons: [UIButton]!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var mapStyleToolbarButton: UIBarButtonItem!

    private var locationManager:CLLocationManager?
    private let distanceSpan:Double = 500
    private var region = MKCoordinateRegion()
    private var venueArray = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

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
            pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
            pin?.image = UIImage(named: "Arrow")
            pin?.backgroundColor = UIColor.blueColor()
        }
        
        pin?.canShowCallout = true
        
        return pin
    }

    override func viewDidLayoutSubviews() {
        
        if mapView.mapType == .Standard {
            changeButtonColorToBlack()
        }
        
        for button in annotationButtons {
            button.layer.cornerRadius = button.frame.size.width/2
        }
        
        allBarsButton.layer.cornerRadius = self.allBarsButton.frame.size.width/2
        clubsButton.layer.cornerRadius = self.clubsButton.frame.size.width/2
        diveBarButton.layer.cornerRadius = self.diveBarButton.frame.size.width/2
        sportsBarButton.layer.cornerRadius = self.sportsBarButton.frame.size.width/2
        casinosButton.layer.cornerRadius = self.casinosButton.frame.size.width/2
        
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
    
    @IBAction func findClubs(sender: AnyObject) {
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        let danceClubSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        danceClubSearch.localSearch(region, queryTerm: "Dance Clubs")

    }
    
    @IBAction func findDiveBars(sender: AnyObject) {
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        let diveBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        diveBarSearch.localSearch(region, queryTerm: "Dive Bar")
    }
    
    @IBAction func findSportsBars(sender: AnyObject) {
        venueArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        let sportsBarSearch = LocalSearchAPI(venueArray: venueArray, mapView: mapView)
        sportsBarSearch.localSearch(region, queryTerm: "Sports Bar")
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
    
    @IBAction func showOrHideToolbar(sender: AnyObject) {
        
        if toolbar.hidden == false {
            toolbar.hidden = true
        } else {
            toolbar.hidden = false
        }
        
    }
    
    
}


