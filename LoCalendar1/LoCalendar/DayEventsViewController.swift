//
//  DayEventsViewController.swift
//  LoCalendar
//
//  Created by Drew Roberts on 4/24/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class DayEventsViewController: UIViewController, MKMapViewDelegate {
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    let eventView = UIView()
    
    let initialLocation = CLLocation(latitude: LocationManager().getGeoLocation().coordinate.latitude, longitude: LocationManager().getGeoLocation().coordinate.longitude)
    let regionRadius = 1000.0
    
    // TESTING PIN
    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(LocationManager().getGeoLocation().coordinate.latitude, LocationManager().getGeoLocation().coordinate.longitude)
    let objectAnnotation = MKPointAnnotation()

    var mapContainerConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(mapContainer)
        self.view.addSubview(eventView)
        eventView.autoPinEdgeToSuperviewEdge(.Bottom)
        eventView.autoPinEdgeToSuperviewEdge(.Right)
        eventView.autoPinEdgeToSuperviewEdge(.Left)
        eventView.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.4)
        
        mapContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0)
        
//        mapContainerConstraint = mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.6)
        mapContainerConstraint = mapContainer.autoPinEdge(.Bottom, toEdge: .Top, ofView: eventView)
        
        //map
        mapContainer.addSubview(myMap)
        myMap.autoPinEdgesToSuperviewEdges()
        myMap.delegate = self
        print(initialLocation.coordinate.latitude, "   ", initialLocation.coordinate.longitude)
        centerMapOnLocation(initialLocation)
        
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Mobile Applications"
        myMap.addAnnotation(objectAnnotation)
        
        // TESTING PIN
//        let localSearchRequest = MKLocalSearchRequest()
//        localSearchRequest.naturalLanguageQuery = "Fred Meyer"
//        let localSearch = MKLocalSearch(request: localSearchRequest)
//        localSearch.startWithCompletionHandler{(LocalSearchResponse, error) -> Void
//        in
//            if LocalSearchResponse == nil {
//                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alertController, animated: true, completion: nil)
//                return
//            }
//            else{
//                let pointAnnotation = MKPointAnnotation()
//                pointAnnotation.title = "Get Groceries"
//                pointAnnotation.coordinate = CLLocationCoordinate2DMake(localSearchResponse!.boundingRegion.center.latitude, localSearchResponse!.boundingRegion.center.longitude)
//                
//                
//            }
//        }
        
        
        // ADDING SLIDE ARROW FOR USER TO CHANGE MAP AND EVENTS VIEW SIZES
//        let slideArrow = UIImage(named: "DownArrow.png")
//        let slideArrowView = UIImageView(image: slideArrow)
//        self.view.addSubview(slideArrowView)
//        slideArrowView.autoPinEdge(.Top, toEdge: .Bottom, ofView: myMap, withOffset: 5)
//        slideArrowView.autoAlignAxis(.Vertical, toSameAxisOfView: self.view)
//        slideArrowView.autoSetDimension(.Height, toSize: 50)
//        slideArrowView.autoSetDimension(.Width, toSize: 100)
        let slideArrow = UIView()
        slideArrow.backgroundColor = UIColor.redColor()
        slideArrow.autoSetDimension(.Height, toSize: 100)
        slideArrow.autoSetDimension(.Width, toSize: 100)
        self.view.addSubview(slideArrow)
        slideArrow.autoPinEdge(.Top, toEdge: .Bottom, ofView: myMap, withOffset: 5)
        
        let slide = UIPanGestureRecognizer(target: self, action: "changeDimensions:")
        slideArrow.addGestureRecognizer(slide)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        myMap.setRegion(coordinateRegion, animated: true)
    }
    
    func changeDimensions(s: UIPanGestureRecognizer){
        mapContainerConstraint.constant = s.translationInView(self.view).y
//            s.locationInView(self.view).y
    }
}
