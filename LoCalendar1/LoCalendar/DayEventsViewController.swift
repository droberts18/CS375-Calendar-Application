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
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    let eventView = UIView()
    var eventViewSliderArrowDown:UIImageView? = nil //(named: "DownArrow.png")
    var eventViewSliderArrowUp:UIImageView? = nil //(named: "UpArrow.png")
    var eventViewSliderArrow:UIImageView? = nil
    var eventViewSlider = UIView()
    
    let initialLocation = CLLocation(latitude: LocationManager().getGeoLocation().coordinate.latitude, longitude: LocationManager().getGeoLocation().coordinate.longitude)
    let regionRadius = 1000.0
    
    // TESTING PIN
    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(LocationManager().getGeoLocation().coordinate.latitude, LocationManager().getGeoLocation().coordinate.longitude)
    let objectAnnotation = MKPointAnnotation()

    var mapContainerConstraint = NSLayoutConstraint()
    var halfShowingArrowConstraint = NSLayoutConstraint()
    var bottomOfMapArrowConstraint = NSLayoutConstraint()
    var heightOfMapConstraint = NSLayoutConstraint()
    var bottomMapConstraint = NSLayoutConstraint()
    var fullScreenMap = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let downArrow = UIImage(named: "DownArrow.png")
        self.eventViewSliderArrowDown = UIImageView(image: downArrow)
        
        let upArrow = UIImage(named: "UpArrow.png")
        self.eventViewSliderArrowUp = UIImageView(image: upArrow)
        
        self.view.backgroundColor = darkColor
        self.view.addSubview(mapContainer)
        self.view.addSubview(eventView)
        self.view.bringSubviewToFront(mapContainer)
        eventView.autoPinEdgeToSuperviewEdge(.Bottom)
        eventView.autoPinEdgeToSuperviewEdge(.Right)
        eventView.autoPinEdgeToSuperviewEdge(.Left)
        //eventView.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.4)
        
        mapContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0)
        
//        mapContainerConstraint = mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.6)
        mapContainerConstraint = mapContainer.autoPinEdge(.Bottom, toEdge: .Top, ofView: eventView)
        heightOfMapConstraint = mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: 0.4)
        //bottomMapConstraint = mapContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        bottomMapConstraint = mapContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: 0, relation: .LessThanOrEqual)
        bottomMapConstraint.active = false
        
        
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
        
        
        
        let eventViewSliderSize:CGFloat = 50
        self.eventViewSliderArrow = eventViewSliderArrowDown
        let sizeRatio = (eventViewSliderArrow!.frame.size.width)/(eventViewSliderArrow!.frame.size.height)
        eventViewSliderArrow!.autoSetDimension(.Height, toSize: 20)
        eventViewSliderArrow!.autoMatchDimension(.Width, toDimension: .Height, ofView: eventViewSliderArrow!, withMultiplier: sizeRatio)
        
        eventViewSlider.addSubview(eventViewSliderArrow!)
        eventViewSliderArrow!.autoCenterInSuperview()
        
        eventViewSlider.autoSetDimension(.Width, toSize: eventViewSliderSize)
        eventViewSlider.autoSetDimension(.Height, toSize: eventViewSliderSize)
        eventViewSlider.layer.cornerRadius = eventViewSliderSize/2
        eventViewSlider.backgroundColor = darkColor
        self.view.addSubview(eventViewSlider)
        eventViewSlider.userInteractionEnabled = true
        
        
        
        
        
        
        
        
//        let eventViewSlider = UIImageView(image: eventViewSliderArrow)
//        eventViewSlider.contentMode = UIViewContentMode.ScaleAspectFit
//        eventViewSlider.clipsToBounds = true
//        eventViewSlider.autoSetDimension(.Height, toSize: 40)
//        eventViewSlider.autoSetDimension(.Width, toSize: 40)
//        eventViewSlider.layer.cornerRadius = eventViewSlider.frame.size.width/2
//        eventViewSlider.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(eventViewSlider)
//        eventViewSlider.userInteractionEnabled = true
//        eventViewSlider.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: eventView, withOffset: eventViewSlider.frame.size.height/2, relation: .GreaterThanOrEqual)
//        eventViewSlider.autoConstrainAttribute(.Bottom, toAttribute: .Bottom, ofView: eventView, withMultiplier: 1, relation: .GreaterThanOrEqual)
        
        self.bottomOfMapArrowConstraint = eventViewSlider.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: mapContainer, withOffset: -5)
        self.bottomOfMapArrowConstraint.active = false
        self.halfShowingArrowConstraint = eventViewSlider.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: mapContainer, withOffset: eventViewSliderSize/2)
        eventViewSlider.autoAlignAxisToSuperviewAxis(.Vertical)
        
//        let slideArrow = UIView()
//        slideArrow.backgroundColor = UIColor.redColor()
//        slideArrow.autoSetDimension(.Height, toSize: 100)
//        slideArrow.autoSetDimension(.Width, toSize: 100)
//        self.view.addSubview(slideArrow)
//        slideArrow.autoPinEdge(.Top, toEdge: .Bottom, ofView: myMap, withOffset: 5)
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(DayEventsViewController.changeDimensions(_:)))
        let arrowTap = UITapGestureRecognizer(target: self, action: #selector(DayEventsViewController.slideOnTap(_:)))
        eventViewSlider.addGestureRecognizer(slide)
        eventViewSlider.addGestureRecognizer(arrowTap)
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
        if(!self.fullScreenMap){
            if(s.state == UIGestureRecognizerState.Ended && s.locationInView(self.view).y >= self.view.frame.height*(1/5) && s.velocityInView(self.view).y > 0){
                print(self.view.frame.height*(1/5))
                print(s.locationInView(self.view).y)
                print("Slide down velocity: ", s.velocityInView(self.view))
                slideDownAnimation()
            }
        }else{
            if(s.state == UIGestureRecognizerState.Ended && s.locationInView(self.view).y <= self.view.frame.height && s.velocityInView(self.view).y < 0){
                print(self.view.frame.height*(1/5))
                print(s.locationInView(self.view).y)
                print("Slide up velocity: ", s.velocityInView(self.view))
                slideUpAnimation()
            }
        }
    }
    
    func slideDownAnimation(){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            //self.eventViewSliderArrow = self.eventViewSliderArrowUp
            self.eventViewSlider.transform = CGAffineTransformMakeRotation(180 * CGFloat(M_PI)/180)
            self.halfShowingArrowConstraint.active = false
            self.heightOfMapConstraint.active = false
            self.bottomOfMapArrowConstraint.active = true
            //self.heightOfMapConstraint.constant = self.view.frame.size.height
            self.bottomMapConstraint.active = true
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            //                self.eventView.center.y = self.view.frame.height
            }, completion: { finished in
                self.fullScreenMap = true
        })

    }
    
    func slideUpAnimation(){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            //self.eventViewSliderArrow = self.eventViewSliderArrowDown
            self.eventViewSlider.transform = CGAffineTransformIdentity
            
            self.bottomMapConstraint.active = false
            self.bottomOfMapArrowConstraint.active = false
            
            self.halfShowingArrowConstraint.active = true
            self.heightOfMapConstraint.active = true
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.fullScreenMap = false
        })
    }
    
    func slideOnTap(s: UITapGestureRecognizer){
        if(!fullScreenMap){
            
            slideDownAnimation()
        }
        else{
            slideUpAnimation()
        }
    }
}
