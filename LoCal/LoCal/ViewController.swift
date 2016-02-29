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
    var sideBarWidth : CGFloat = 70
    let animationTime = 0.4
    var translationOffset : CGFloat = 0
    var calendarViewAnimationRatio : CGFloat = 5
    let backgColor = UIColor(red: 42/255, green: 45/255, blue: 53/255, alpha: 1)
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Month Description View
        let monthDescViewHeight : CGFloat = 50
        let monthDescView = UIView(forAutoLayout: ())
        self.view.addSubview(monthDescView)
        monthDescView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        monthDescView.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        monthDescView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        monthDescView.autoSetDimension(.Height, toSize: monthDescViewHeight)
        monthDescView.backgroundColor = sidebColor
        monthDescView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 0)
        //end month description view
        
        //Container View
        let myContainer = UIView(forAutoLayout: ())
        self.view.addSubview(myContainer)
        myContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        myContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        myContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.view)
        //end container view
        
        //Calendar View
        let calendarView = UIView(forAutoLayout: ())
        self.view.addSubview(calendarView)
        calendarView.backgroundColor = backgColor
        self.view.addSubview(calendarView)
        //calendarView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, sideBarWidth, 0, 0)) //make calendarView the size of the remaining screen
        calendarView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        calendarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        calendarView.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthDescView, withOffset: 0)
        //end calendar view
        
        //Sidebar
        let sideBar  = UIView()
        sideBar.backgroundColor = sidebColor
        self.view.addSubview(sideBar)
        sideBar.autoPinEdgeToSuperviewEdge(.Top)
        sideBar.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view)
        sideBar.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view)
        sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView, withOffset: 0)
        self.sideBarLayoutConstraint = sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: self.view, withOffset: sideBarWidth)
        
        let mapContainer = UIView()
        sideBar.addSubview(mapContainer)
        mapContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthDescView, withOffset: 0)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: sideBar, withOffset: 0)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: sideBar, withOffset: 0)
        mapContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar, withOffset: -300)
        
        let myMap = MKMapView()
        mapContainer.addSubview(myMap)
        myMap.autoPinEdgesToSuperviewEdges()
        
        let dateTable = UITableView()
        dateTable.backgroundColor = UIColor.blackColor()
        sideBar.addSubview(dateTable)
        dateTable.autoPinEdge(.Top, toEdge: .Top, ofView: sideBar)
        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sideBar)
        dateTable.autoPinEdge(.Left, toEdge: .Right, ofView: myMap)
        dateTable.autoPinEdge(.Right, toEdge: .Right, ofView: sideBar)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        sideBar.addGestureRecognizer(panGesture)
        //end sidebar
        
        let rect = CGRectMake(220, 100, 50, 50)
        let addEventBtn = UIButton(frame: rect)
        addEventBtn.backgroundColor = UIColor.blueColor()
        sideBar.addSubview(addEventBtn)
        
        calendarView.addSubview(addEventBtn)
    }
    
    func showSideBar(){
        sideBarLayoutConstraint?.constant = self.view.frame.size.width
        UIView.animateWithDuration(animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
                
        })
    }
    
    func hideSideBar(){
        sideBarLayoutConstraint?.constant = sideBarWidth
        UIView.animateWithDuration(animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
                
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

