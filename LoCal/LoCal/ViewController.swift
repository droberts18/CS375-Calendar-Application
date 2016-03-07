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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var panningConstraint : NSLayoutConstraint?
    var sideBarWidthConstraint : NSLayoutConstraint?
    var sideBarWidth : CGFloat = 70
    
    //Button stuff
    var navButtonSize : CGFloat = 60
    var navButtonImageSize : CGFloat = 40
    var navButtonBorderWidth : CGFloat = 2
    var navButtonBorderColor = UIColor.whiteColor()
    
    let animationTime = 0.5
    var translationOffset : CGFloat = 0
    var calendarViewAnimationRatio : CGFloat = 5
    let backgColor = UIColor(red: 42/255, green: 45/255, blue: 53/255, alpha: 1)
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let addEventButtonColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    
    let myContainer = UIView(forAutoLayout: ())
    let calendarContainer = UIView(forAutoLayout: ())
    let calendarView = CalendarEventTable(forAutoLayout: ())
    let sideBar  = UIView(forAutoLayout: ())
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    let dateTable = CalendarDateTable(forAutoLayout: ())
    
    var addEventButton = NavButton()
    var addEventButtonBottomConstraint : NSLayoutConstraint?
    var addEventButtonRightConstraint : NSLayoutConstraint?

    
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
        
        
        
        
        //FIXME:
        //myContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0, relation: .LessThanOrEqual).priority.advancedBy(5000)
        
        
        
        
        myContainer.userInteractionEnabled = true
        calendarContainer.userInteractionEnabled = true
        calendarView.userInteractionEnabled = true
        //dateTable.userInteractionEnabled = true
        sideBar.userInteractionEnabled = true
        
        myContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        //dateTable.translatesAutoresizingMaskIntoConstraints = false
        sideBar.translatesAutoresizingMaskIntoConstraints = false
        
        //Calendar View
        myContainer.addSubview(calendarContainer)
        //calendar container
        calendarContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: myContainer, withMultiplier: 0.5)
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
        addEventButton = NavButton(buttonColor: addEventButtonColor, imageFileName: "AddEventButtonPlus.png")
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.addSubview(addEventButton)
        addEventButtonBottomConstraint = addEventButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarView, withOffset: -10)
        addEventButtonRightConstraint = addEventButton.autoPinEdge(.Right, toEdge: .Right, ofView: calendarView, withOffset: -10)
        addEventButton.addTarget(self, action: "onEventButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)

        
        //date table
        calendarContainer.addSubview(dateTable)
        dateTable.backgroundColor = sidebColor
        dateTable.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        dateTable.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView, withOffset: 1)
        dateTable.autoSetDimension(.Width, toSize: sideBarWidth + 1)
        
        //Side Bar
        myContainer.addSubview(sideBar)
        sideBar.backgroundColor = sidebColor
        sideBar.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        sideBar.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: myContainer)
        sideBar.autoPinEdge(.Right, toEdge: .Left, ofView: calendarContainer, withOffset: 1)
        sideBar.autoPinEdge(.Left, toEdge: .Left, ofView: myContainer)
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
        myMap.alpha = 0  //hide map

        //adding pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        myContainer.addGestureRecognizer(panGesture)
        
    }
    
    func onEventButtonTap(sender:UIButton!){
//        addEventButton.animateButton(self.view.frame.width, height: self.view.frame.height, bottomConstraint: addEventButtonBottomConstraint!, rightConstraint: addEventButtonRightConstraint!)
        let addEventViewController = AddEventViewController(backgroundColor: addEventButtonColor)
        //addEventViewController.view.alpha = 0
        self.presentViewController(addEventViewController, animated: true, completion: nil)
//        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
//                addEventViewController.view.alpha = 1
//            }, completion: nil)
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
        UIView.animateWithDuration(self.animationTime, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.myMap.alpha = 0
        })
    }
    
    func translateScreens(translation: CGPoint, sideBarRightEdgeLocation: CGFloat){
        panningConstraint?.constant = translationOffset + translation.x
    }
    
    func onPanGesture(g: UIPanGestureRecognizer){
        if let view = g.view{
            let translation = g.locationInView(self.view)
            let newTranslation : CGPoint

            //if the gesture started, record the offset of the finger's initial tap location in relation to the screen
            if(g.state == UIGestureRecognizerState.Began){
                newTranslation = g.locationInView(view)
                translationOffset = self.view.frame.size.width - newTranslation.x
            }
                
            if(g.velocityInView(view).x > 0){
                if(g.velocityInView(view).x > 30 && g.state == UIGestureRecognizerState.Ended){
                        showSideBar()
                }else{
                        translateScreens(translation, sideBarRightEdgeLocation: view.frame.maxX/2)
                }
            }else{
                if(g.velocityInView(view).x < -30 && g.state == UIGestureRecognizerState.Ended){
                        hideSideBar()
                }else{
                    translateScreens(translation, sideBarRightEdgeLocation: view.frame.maxX/2)
                }
            }
         
            if(g.state == UIGestureRecognizerState.Ended){
                if(g.state == UIGestureRecognizerState.Ended && self.view.frame.size.width/view.frame.maxX > 0.65){
                    hideSideBar()
                }else{
                    showSideBar()
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
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        return cell
    }


}

