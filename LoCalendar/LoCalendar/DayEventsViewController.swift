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
    
    let initialLocation = CLLocation(latitude: LocationManager().getGeoLocation().coordinate.latitude, longitude: LocationManager().getGeoLocation().coordinate.longitude)
    let regionRadius = 1000.0
    
    // TESTING PIN
    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(LocationManager().getGeoLocation().coordinate.latitude, LocationManager().getGeoLocation().coordinate.longitude)
    let objectAnnotation = MKPointAnnotation()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(mapContainer)
        mapContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0)
        mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.6)
        
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
//        localSearchRequest.naturalLanguageQuery = "Spokane"
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
}
