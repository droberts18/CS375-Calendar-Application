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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    //These will eventually be replaced with day objects
    let events : [EventView] = [EventView(time: "2:55pm", title: "Mobile App Development", location: "Whitworth University"), EventView(time: "4:50pm", title: "Artificial Intelligence", location: "Eric Johnston 301")]
    //end
    
    let calendarManager : CalendarManager = CalendarManager()
    

    var panningConstraint : NSLayoutConstraint?
    var sideBarWidthConstraint : NSLayoutConstraint?
    var sideBarWidth : CGFloat = 65
    
    //Button stuff
    var navButtonSize : CGFloat = 60
    var navButtonImageSize : CGFloat = 40
    var navButtonBorderWidth : CGFloat = 2
    var navButtonBorderColor = UIColor.whiteColor()
    var buttonOffset : CGFloat = 10
    
    let animationTime = 0.5
    var translationOffset : CGFloat = 0
    var calendarViewAnimationRatio : CGFloat = 5
    
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let backgColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let addEventButtonColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let addLocationButtonColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let statusBarView = UIView(forAutoLayout: ())
    let myContainer = UIView(forAutoLayout: ())
    
    let calendarContainer = UIView(forAutoLayout: ())
    let calendarView = UITableView(forAutoLayout: ())
    let dateTable = UITableView(forAutoLayout: ())
    
    let yearAndDateContainer = UIView(forAutoLayout: ())
    var yearDesc = UILabel(forAutoLayout: ())
    var monthDesc = UILabel(forAutoLayout: ())
    
    
    let sideBar  = UIView(forAutoLayout: ())
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    
    var addEventButton = NavButton()
//    var addEventButtonBottomConstraint : NSLayoutConstraint?
//    var addEventButtonRightConstraint : NSLayoutConstraint?
    
    var addLocationButton = NavButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = sidebColor
        
        //Status Bar View
        let statusBarViewHeight : CGFloat = 20
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
        
        
        //FIXME --> should prevent user from panning right when the sideBar is showing
        //myContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 0, relation: .LessThanOrEqual).priority.advancedBy(5000)
        
        
        myContainer.userInteractionEnabled = true
        calendarContainer.userInteractionEnabled = true
        calendarView.userInteractionEnabled = true
        sideBar.userInteractionEnabled = true
        
        myContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dateTable.translatesAutoresizingMaskIntoConstraints = false
        sideBar.translatesAutoresizingMaskIntoConstraints = false
        
        //Calendar View
        myContainer.addSubview(calendarContainer)
        
        //calendar container --> contains the calendar view and the date table
        calendarContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view)
        calendarContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        calendarContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: myContainer)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: myContainer)
        
        
        //MONTH DESCRIPTION
        calendarContainer.addSubview(yearAndDateContainer)
        yearAndDateContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBarView)
        yearAndDateContainer.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        yearAndDateContainer.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer)
        yearAndDateContainer.autoSetDimension(.Height, toSize: 50)
        yearAndDateContainer.backgroundColor = sidebColor
        
        yearAndDateContainer.addSubview(yearDesc)
        yearAndDateContainer.addSubview(monthDesc)

        monthDesc.textColor = whiteColor
        monthDesc.text = "FEBRUARY"
        monthDesc.autoPinEdge(.Right, toEdge: .Left, ofView: yearDesc, withOffset: -20)
        monthDesc.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer, withOffset: sideBarWidth + 10)
        //monthDesc.autoPinEdge(.Right, toEdge: .Left, ofView: yearDesc, withOffset: -10)
        monthDesc.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        monthDesc.font = monthDesc.font.fontWithSize(40)

        
        yearDesc.textColor = whiteColor
        yearDesc.text = "2016"
        yearDesc.autoPinEdge(.Top, toEdge: .Top, ofView: monthDesc)
        yearDesc.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: monthDesc)
        //yearDesc.autoPinEdge(.Right, toEdge: .Right, ofView: yearAndDateContainer, withOffset: -10)
        yearDesc.font = yearDesc.font.fontWithSize(20)
        //END MONTH DESCRIPTION
        
        
        //CALENDAR TABLES ----------------------------------------------------------------
        //calendar view --> where events are displayed
        calendarContainer.addSubview(calendarView)
        calendarView.backgroundColor = backgColor
        calendarView.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        calendarView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        calendarView.autoPinEdge(.Top, toEdge: .Bottom, ofView: yearAndDateContainer)
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withOffset: -sideBarWidth)
        calendarView.separatorColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 0.5)
        calendarView.separatorStyle = .SingleLine
        calendarView.showsVerticalScrollIndicator = false
        calendarView.showsHorizontalScrollIndicator = false
        //set up calendar view table
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerClass(CalendarEventCell.self, forCellReuseIdentifier: "CalendarEventCell")
        
        //date table --> displays the days and dates of the week
//        calendarContainer.addSubview(dateTable)
        calendarContainer.insertSubview(dateTable, belowSubview: calendarView)
        dateTable.backgroundColor = sidebColor
        dateTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: yearAndDateContainer)
        dateTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        dateTable.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView, withOffset: 1)
        dateTable.autoSetDimension(.Width, toSize: sideBarWidth + 1)
        dateTable.separatorColor = UIColor.darkGrayColor()
        dateTable.separatorStyle = .None
        dateTable.showsVerticalScrollIndicator = false
        dateTable.showsHorizontalScrollIndicator = false
        //set up date table
        dateTable.dataSource = self;
        dateTable.delegate = self;
        dateTable.registerClass(CalendarDateCell.self, forCellReuseIdentifier: "CalendarDateCell")
        //END CALENDAR TABLES ----------------------------------------------------------------
        

        
        //BUTTONS ----------------------------------------------------------------
        //add event button --> brings up add event screen
        addEventButton = NavButton(buttonColor: addEventButtonColor, imageFileName: "AddEventButtonPlus.png")
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.addSubview(addEventButton)
        addEventButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer, withOffset: -self.buttonOffset)
        addEventButton.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer, withOffset: -self.buttonOffset)
        addEventButton.addTarget(self, action: "onEventButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //add location button --> brings up add location screen
        addLocationButton = NavButton(buttonColor: addLocationButtonColor, imageFileName: "AddLocation.png")
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.addSubview(addLocationButton)
        addLocationButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer, withOffset: -self.buttonOffset)
        addLocationButton.autoPinEdge(.Right, toEdge: .Left, ofView: addEventButton, withOffset: -self.buttonOffset)
        addLocationButton.addTarget(self, action: "onLocationButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        //END BUTTONS ----------------------------------------------------------------
        
        
        
        //Side Bar --> contains the map as well as a list of the days events
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
    
    //BUTTON FUNCTIONS ----------------------------------------------------------------------------------------------------------
    func onEventButtonTap(sender:UIButton!){
        let addEventViewController = AddEventViewController(backgroundColor: addEventButtonColor)
        self.presentViewController(addEventViewController, animated: true, completion: nil)
    }
    
    func onLocationButtonTap(sender:UIButton!){
        let addLocationViewController = AddLocationViewController(backgroundColor: addLocationButtonColor)
        self.presentViewController(addLocationViewController, animated: true, completion: nil)
    }
    
    
    //PANNING FUNCTIONS ----------------------------------------------------------------------------------------------------------
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
            
            
            //if the user swipes, either show or hide the sideBar
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
         
            //depending on the ending position of the view when the gesture stops, hide or show the sideBar
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
    
    
    //TABLE VIEW FUNCTIONS ----------------------------------------------------------------------------------------------------------
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 31
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(self.events.count > 0){
            return 25 + CGFloat(self.events.count)*(self.events.first?.eventHeight)!
        }else{
            return 75
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell? = nil
        if(tableView == self.calendarView){
            let eventCell = tableView.dequeueReusableCellWithIdentifier("CalendarEventCell", forIndexPath: indexPath) as! CalendarEventCell
            eventCell.backgroundColor = backgColor
            
            var lastEvent : EventView = EventView()
            var first : Bool = true
            
            for event in self.events{
                eventCell.contentView.addSubview(event)
                event.autoPinEdge(.Left, toEdge: .Left, ofView: eventCell.contentView)
                event.autoMatchDimension(.Width, toDimension: .Width, ofView: eventCell.contentView)
                if(first){
                    first = false
                    event.autoPinEdge(.Top, toEdge: .Top, ofView: eventCell.contentView)
                }else{
                    event.autoPinEdge(.Top, toEdge: .Bottom, ofView: lastEvent) //stack events on top of each other
                }
                
                lastEvent = event //store the last event so events can stack
            }
            cell = eventCell
        }else{
            let dateCell = tableView.dequeueReusableCellWithIdentifier("CalendarDateCell", forIndexPath: indexPath) as! CalendarDateCell
            dateCell.backgroundColor = sidebColor
            dateCell.dayName.text = "TUE"
            dateCell.dayDate.text = String(indexPath.row + 1)
            
            cell = dateCell
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.calendarView){
            self.dateTable.contentOffset = CGPointMake(0.0, scrollView.contentOffset.y)
        }else if (scrollView == self.dateTable){
            self.calendarView.contentOffset = CGPointMake(0.0, scrollView.contentOffset.y)
        }
    }
    
    //select functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.calendarView){
            self.dateTable.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }else if (tableView == self.dateTable){
            self.calendarView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
    }


}

