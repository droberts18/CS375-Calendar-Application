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

    var sideBarLayoutConstraint : NSLayoutConstraint?
    var sideBarWidthConstraint : NSLayoutConstraint?
    var sideBarWidth : CGFloat = 70
    let animationTime = 0.4
    var translationOffset : CGFloat = 0
    var calendarViewAnimationRatio : CGFloat = 5
    let backgColor = UIColor(red: 42/255, green: 45/255, blue: 53/255, alpha: 1)
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    
    let sideBar  = UIView()
    let mapContainer = UIView()
    let myMap = MKMapView()
    let dateTable = UITableView()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Month Description View
        let statusBarViewHeight : CGFloat = 20
        let statusBarView = UIView(forAutoLayout: ())
        self.view.addSubview(statusBarView)
        statusBarView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBarView.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBarView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBarView.autoSetDimension(.Height, toSize: statusBarViewHeight)
        statusBarView.backgroundColor = sidebColor
        statusBarView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        //end month description view
        
//        //Container View
//        let myContainer = UIView(forAutoLayout: ())
//        self.view.addSubview(myContainer)
//        myContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        myContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        myContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
//        myContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthDescView)
//        //end container view
        
        //Calendar View
        let calendarView = UIView(forAutoLayout: ())
        self.view.addSubview(calendarView)
        calendarView.backgroundColor = backgColor
        self.view.addSubview(calendarView)
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withOffset: -sideBarWidth)
        calendarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        calendarView.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView, withOffset: 0)
        //end calendar view
        
        //Sidebar
        sideBar.backgroundColor = sidebColor
        self.view.addSubview(sideBar)
        sideBar.autoPinEdgeToSuperviewEdge(.Top)
        sideBar.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view)
        sideBar.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view)
        sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView, withOffset: 0)
        self.sideBarLayoutConstraint = sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: self.view, withOffset: sideBarWidth)
        
        dateTable.backgroundColor = sidebColor
        sideBar.addSubview(dateTable)
        dateTable.autoPinEdge(.Top, toEdge: .Top, ofView: sideBar)
        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar)
        dateTable.autoPinEdge(.Right, toEdge: .Right, ofView: sideBar)
        dateTable.autoSetDimension(.Width, toSize: sideBarWidth)
        

        sideBar.insertSubview(mapContainer, belowSubview: dateTable)
        mapContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: sideBar, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: dateTable, withOffset: 0)
        mapContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar, withOffset: -300)
        
        mapContainer.addSubview(myMap)
        myMap.autoPinEdgesToSuperviewEdges()
        myMap.alpha = 0                         //hide map
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        sideBar.addGestureRecognizer(panGesture)
        //end sidebar
        
        
        let rect = CGRectMake(0, 0, 50, 50)
        let addEventBtn = UIButton(frame: rect)
        addEventBtn.backgroundColor = UIColor.blueColor()
        sideBar.addSubview(addEventBtn)
        
        calendarView.addSubview(addEventBtn)
        
        //add event button
        let addEventImage = UIImage(named: "AddEventButton.png")
        let addEventImageView = UIImageView(image: addEventImage)
        calendarView.addSubview(addEventImageView)
        addEventImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -10)
        addEventImageView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -10)
        addEventImageView.autoSetDimension(.Height, toSize: 60)
        addEventImageView.autoSetDimension(.Width, toSize: 60)
        
        //add location button
        let addLocationImage = UIImage(named: "AddLocationButton.png")
        let addLocationImageView = UIImageView(image: addLocationImage)
        calendarView.addSubview(addLocationImageView)
        addLocationImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -10)
        addLocationImageView.autoPinEdge(.Right, toEdge: .Left, ofView: addEventImageView, withOffset: -10)
        addLocationImageView.autoSetDimension(.Height, toSize: 60)
        addLocationImageView.autoSetDimension(.Width, toSize: 60)
        
        
        
        //let outerCircle = UI
        
    }
    
    func showSideBar(){
        sideBarLayoutConstraint?.constant = self.view.frame.size.width
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
        sideBarLayoutConstraint?.constant = sideBarWidth
        UIView.animateWithDuration(animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.myMap.alpha = 0
        })
    }
    
    func translateScreens(translation: CGPoint, sideBarRightEdgeLocation: CGFloat){
        sideBarLayoutConstraint?.constant = translationOffset + translation.x
    }
    
    func onPanGesture(g: UIPanGestureRecognizer){
        if let view = g.view{
            let translation = g.locationInView(self.view)
            let newTranslation : CGPoint

            //don't let the sideBar go left if it's already minimized
            if((g.velocityInView(view).x < 0 && view.frame.maxX <= sideBarWidth) || (g.velocityInView(view).x) > 0 && view.frame.maxX >= self.view.frame.width){
                return
            }
            
            
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

