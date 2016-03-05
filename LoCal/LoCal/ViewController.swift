//
//  ViewController.swift
//  LoCal
//
//  Created by Tyler Reardon on 2/23/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    var panningConstraint : NSLayoutConstraint?
    var sideBarWidthConstraint : NSLayoutConstraint?
    var sideBarWidth : CGFloat = 70
    
    //Button stuff
    var navButtonSize : CGFloat = 60
    var navButtonImageSize : CGFloat = 40
    var navButtonBorderWidth : CGFloat = 2
    var navButtonBorderColor = UIColor.whiteColor()
    
    let animationTime = 0.4
    var translationOffset : CGFloat = 0
    var calendarViewAnimationRatio : CGFloat = 5
    let backgColor = UIColor(red: 42/255, green: 45/255, blue: 53/255, alpha: 1)
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let addEventButtonColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    
    let myContainer = UIView(forAutoLayout: ())
    let calendarContainer = UIView(forAutoLayout: ())
    let calendarView = UIView(forAutoLayout: ())
    let sideBar  = UIView(forAutoLayout: ())
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    let dateTable = UITableView(forAutoLayout: ())
    let eventView = UIView(forAutoLayout: ())
    let addEventButton = UIButton(forAutoLayout: ())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Status Bar View
        let statusBarViewHeight : CGFloat = 20
        let statusBarView = UIView(forAutoLayout: ())
        self.view.addSubview(statusBarView)
        statusBarView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBarView.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBarView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBarView.autoSetDimension(.Height, toSize: statusBarViewHeight)
        statusBarView.backgroundColor = sidebColor
        statusBarView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        //end status bar view
        
        //Container View
        self.view.addSubview(myContainer)
        myContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 2)
        myContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        myContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        myContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0, relation: .GreaterThanOrEqual)
        
        myContainer.userInteractionEnabled = true
        calendarContainer.userInteractionEnabled = true
        calendarView.userInteractionEnabled = true
        dateTable.userInteractionEnabled = true
        sideBar.userInteractionEnabled = true
        
        myContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dateTable.translatesAutoresizingMaskIntoConstraints = false
        sideBar.translatesAutoresizingMaskIntoConstraints = false
        
        //Calendar View
        myContainer.addSubview(calendarContainer)
        //calendar container
        calendarContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: myContainer, withMultiplier: 0.5)
        //calendarContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withOffset: 1)
        calendarContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        calendarContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: myContainer)
        //calendar view
        calendarContainer.addSubview(calendarView)
        calendarView.backgroundColor = backgColor
        calendarView.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        calendarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        calendarView.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withOffset: -sideBarWidth)
        
        //add event button
        let addLocationButton = NavButton(buttonColor: addEventButtonColor, imageFileName: "AddEventButtonPlus.png")
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addSubview(addLocationButton)
        addLocationButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarView, withOffset: -10)
        addLocationButton.autoPinEdge(.Right, toEdge: .Right, ofView: calendarView, withOffset: -10)
        addLocationButton.addTarget(self, action: "onLocationButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)

        
        //date table
        calendarView.addSubview(dateTable)
        dateTable.backgroundColor = sidebColor
        dateTable.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        dateTable.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView)
        dateTable.autoSetDimension(.Width, toSize: sideBarWidth)
        
        //Side Bar
        myContainer.addSubview(sideBar)
        sideBar.backgroundColor = sidebColor
        sideBar.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        sideBar.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: myContainer)
        sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: calendarContainer, withOffset: 1)
        sideBar.autoPinEdge(.Left, toEdge: .Left, ofView: myContainer)
        //sideBar.autoMatchDimension(.Width, toDimension: .Width, ofView: myContainer, withMultiplier: 0.5)
        sideBar.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withOffset: 1)
        
        //panning constraint
        panningConstraint = sideBar.autoConstrainAttribute(.Right, toAttribute: .Left, ofView: self.view, withOffset: 0, relation: .GreaterThanOrEqual)
        
        //map container
        sideBar.addSubview(mapContainer)
        mapContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: sideBar, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: sideBar, withOffset: 0)
        mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: sideBar, withMultiplier: 0.4)
        //map
        mapContainer.addSubview(myMap)
        myMap.autoPinEdgesToSuperviewEdges()
        //myMap.alpha = 0  //hide map

        //adding pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        myContainer.addGestureRecognizer(panGesture)
        
        
        
        
        
        
        
        
//        self.view.addSubview(calendarView)
//        calendarView.backgroundColor = backgColor
//        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withOffset: -sideBarWidth)
//        calendarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
//        calendarView.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView, withOffset: 0)
//        calendarView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 0, relation: .GreaterThanOrEqual)
        //end calendar view
        
        //Sidebar
//        sideBar.backgroundColor = sidebColor
//        self.view.addSubview(sideBar)
//        sideBar.autoPinEdgeToSuperviewEdge(.Top)
//        sideBar.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view)
//        sideBar.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view)
//        sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView, withOffset: 0)
        //self.sideBarLayoutConstraint = sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: self.view, withOffset: sideBarWidth)
        
//        dateTable.backgroundColor = sidebColor
//        sideBar.addSubview(dateTable)
//        dateTable.autoPinEdge(.Top, toEdge: .Top, ofView: sideBar)
//        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar)
//        dateTable.autoPinEdge(.Right, toEdge: .Right, ofView: sideBar)
//        self.sideBarWidthConstraint = dateTable.autoSetDimension(.Width, toSize: sideBarWidth)
        
        //IMPORTANT STUFF
//        sideBar.insertSubview(mapContainer, belowSubview: dateTable)
//        mapContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView, withOffset: 0)
//        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: sideBar, withOffset: 0)
//        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: dateTable, withOffset: -1)
//        mapContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar, withOffset: -300)
//        mapContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: sideBar, withMultiplier: 0.4)
//        mapContainer.addSubview(myMap)
//        myMap.autoPinEdgesToSuperviewEdges()
//        myMap.alpha = 0  //hide map
//        
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
//        sideBar.addGestureRecognizer(panGesture)
//        //end sidebar
//        
//        //add event button
//        let addLocationButton = NavButton(buttonColor: addEventButtonColor, imageFileName: "AddEventButtonPlus.png")
//        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
//        calendarView.addSubview(addLocationButton)
//        addLocationButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarView, withOffset: -10)
//        addLocationButton.autoPinEdge(.Right, toEdge: .Right, ofView: calendarView, withOffset: -10)
//        addLocationButton.autoSetDimension(.Width, toSize: navButtonSize)
//        addLocationButton.autoSetDimension(.Height, toSize: navButtonSize)
        //IMPORTANT STUFF END

    }
    
    func onLocationButtonTap(sender:UIButton!){
        self.presentViewController(AddEventViewController(backgroundColor: addEventButtonColor), animated: true, completion: nil)
    }
    
    func showSideBar(){
        panningConstraint?.constant = self.view.frame.size.width
        UIView.animateWithDuration(self.animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
        })
        
        UIView.animateWithDuration(0.5, animations: {
            self.myMap.alpha = 1.0
        })
    }
    
    func hideSideBar(){
        panningConstraint?.constant = 0
        UIView.animateWithDuration(animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.myMap.alpha = 0
        })
    }
    
    func translateScreens(translation: CGPoint, sideBarRightEdgeLocation: CGFloat){
        print("translationOffset is:\t\t \(translationOffset)")
        print("translation is:\t\t\t\(translation.x)")
        //panningConstraint?.constant = translationOffset + translation.x
        panningConstraint?.constant = translation.x
    }
    
    func onPanGesture(g: UIPanGestureRecognizer){
        if let view = g.view{
            let translation = g.locationInView(self.view)
            let newTranslation : CGPoint
            
//            //don't let the sideBar go left if it's already minimized
//            if((g.velocityInView(view).x < 0 && view.frame.maxX <= sideBarWidth) || (g.velocityInView(view).x) > 0 && view.frame.maxX >= self.view.frame.width){
//                return
//            }
            
            
            //if the gesture started, record the offset of the finger's initial tap location in relation to the screen
            if(g.state == UIGestureRecognizerState.Began){
                newTranslation = g.locationInView(view)
                translationOffset = view.frame.size.width - newTranslation.x
            }
                
            if(g.velocityInView(view).x > 0){
                if((g.velocityInView(view).x > 10 && g.state == UIGestureRecognizerState.Ended) || (g.state == UIGestureRecognizerState.Ended && view.frame.maxX > self.view.frame.size.width/2)){
                        showSideBar()
                }else{
                        translateScreens(translation, sideBarRightEdgeLocation: view.frame.maxX)
                }
            }else{
                if(((g.velocityInView(view).x < 0 && g.state == UIGestureRecognizerState.Ended)) || (g.state == UIGestureRecognizerState.Ended && view.frame.maxX < self.view.frame.size.width/2)){
                        hideSideBar()
                }else{
                    translateScreens(translation, sideBarRightEdgeLocation: view.frame.maxX)
                }
            }
            
        }
        g.setTranslation(CGPointZero, inView: self.view)
    }
    
    func onButtonTap(f: UITapGestureRecognizer){
        print("Tap happened")
    
        //let addEventVC = AddEventViewController()
        //self.presentViewController(AddEventViewController(), animated: true, completion: nil)
        
//        if let view = f.view{
//            addLocationScreenHeight?.constant = self.view.frame.size.height
//            addLocationScreenWidth?.constant = self.view.frame.size.width
//            UIView.animateWithDuration(self.animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
//                self.view.setNeedsLayout()
//                self.view.layoutIfNeeded()
//                }, completion: { finished in
//            })
//        }
    }
    
//
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
//    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

