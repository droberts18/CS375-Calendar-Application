//
//  CalendarScrollViewController.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/14/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

import UIKit

class CalendarScrollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let calendarManager = CalendarManager()
    let calendarContainerHeightMultiplyer = 0.35
    var calendarContainer = UIView()
    var calendarView = CalendarView()
    var forwardMonth = UIButton()
    var backwardMonth = UIButton()
    var dayTable = DayTable(forAutoLayout: ())
    var dayCellHeight = CGFloat()
    
    var currentDaysInView = [NSIndexPath()]
    var dayCellMap = [String:[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(calendarContainer)
        calendarContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        calendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        calendarContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: CGFloat(calendarContainerHeightMultiplyer))
        calendarContainer.backgroundColor = darkColor
        
        calendarContainer.addSubview(calendarView)
        calendarView.autoCenterInSuperview()
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 0.75)
        calendarView.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarContainer)
        self.updateCalendarView()
        
        
        //SIDE BUTTONS
        let rightSide = UIView()
        calendarContainer.addSubview(rightSide)
        rightSide.autoPinEdge(.Left, toEdge: .Right, ofView: calendarView)
        rightSide.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        rightSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        rightSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        rightSide.addSubview(forwardMonth)
        forwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: rightSide, withMultiplier: 1)
        forwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: rightSide, withMultiplier: 1)
        forwardMonth.autoCenterInSuperview()
        let forwardImage = UIImage(named: "ForwardButton.png")
        let forwardButtonImageView = UIImageView(image: forwardImage)
        self.forwardMonth.addSubview(forwardButtonImageView)
        forwardButtonImageView.autoCenterInSuperview()
        forwardButtonImageView.alpha = 0.25
        self.forwardMonth.addTarget(self, action: #selector(CalendarScrollViewController.goForwardOneMonth(_:)), forControlEvents: .TouchUpInside)
        let leftSide = UIView()
        calendarContainer.addSubview(leftSide)
        leftSide.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView)
        leftSide.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer)
        leftSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        leftSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        leftSide.addSubview(backwardMonth)
        backwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: leftSide, withMultiplier: 1)
        backwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: leftSide, withMultiplier: 1)
        backwardMonth.autoCenterInSuperview()
        let backImage = UIImage(named: "BackButton.png")
        let backButtonImageView = UIImageView(image: backImage)
        self.backwardMonth.addSubview(backButtonImageView)
        backButtonImageView.autoCenterInSuperview()
        backButtonImageView.alpha = 0.25
        self.backwardMonth.addTarget(self, action: #selector(CalendarScrollViewController.goBackwardOneMonth(_:)), forControlEvents: .TouchUpInside)
        
        if let width = forwardImage?.size.width{
            if let height = forwardImage?.size.height{
                let ratio = width/height
                forwardButtonImageView.autoSetDimension(.Height, toSize: 30)
                forwardButtonImageView.autoMatchDimension(.Width, toDimension: .Height, ofView: forwardButtonImageView, withMultiplier: ratio)
                backButtonImageView.autoSetDimension(.Height, toSize: 30)
                backButtonImageView.autoMatchDimension(.Width, toDimension: .Height, ofView: backButtonImageView, withMultiplier: ratio)
            }
        }
        //END SIDE BUTTONS
        
        self.view.addSubview(dayTable)
        dayTable.backgroundColor = lightDarkColor
        dayTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarContainer)
        dayTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        dayTable.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        dayTable.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        dayTable.dataSource = self;
        dayTable.delegate = self;
        dayTable.registerClass(CalendarScrollCell.self, forCellReuseIdentifier: "CalendarScrollCell")
        dayTable.showsVerticalScrollIndicator = false
        dayTable.showsHorizontalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        dayCellHeight = self.dayTable.frame.height/7
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    //TABLE VIEW FUNCTIONS
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.calendarManager.numberOfDaysLoaded
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return dayCellHeight
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let dayTable = scrollView as? DayTable{
            var scrollDirection = dayTable.panGestureRecognizer.velocityInView(dayTable).y
            if scrollDirection != 0{
                dayTable.getScrollDirection(scrollDirection)
            }
            if let indices = dayTable.indexPathsForVisibleRows {
                self.currentDaysInView = indices
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var dayCell = tableView.dequeueReusableCellWithIdentifier("CalendarScrollCell", forIndexPath: indexPath) as! CalendarScrollCell
        //dayCell.dayDate.text = "\(indexPath.row)"
        
        
        
        return dayCell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        self.autoShowCompleteCell(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(!decelerate){
            self.autoShowCompleteCell(scrollView)
        }
    }
    
    func autoShowCompleteCell(scrollView: UIScrollView){
        if let dayTable = scrollView as? DayTable{
            if dayTable.dayTableScrollDirection == DayTable.ScrollDirections.Up{
                if let first = self.currentDaysInView.first{
                    dayTable.scrollToRowAtIndexPath(first, atScrollPosition: .Top, animated: true)
                }
            }else if dayTable.dayTableScrollDirection == DayTable.ScrollDirections.Down{
                if let last = self.currentDaysInView.last{
                    dayTable.scrollToRowAtIndexPath(last, atScrollPosition: .None, animated: true)
                }
            }
        }
    }
    
    //CALENDAR FUNCTIONS
    func onDateButtonTap(sender:UIButton!){
        let selectedDate = sender as? CalendarViewDateButton
        if let date = selectedDate{
            print(date.getDate())
            var indexPath = NSIndexPath(forItem: 0, inSection: 0)
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
    func updateCalendarView(){
        for date in self.calendarView.dateContainers{
            date.addTarget(self, action: #selector(CalendarScrollViewController.onDateButtonTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

    func goForwardOneMonth(sender:UIButton!){
        calendarView.goForwardOneMonth()
        
        updateCalendarView()
    }
    
    func goBackwardOneMonth(sender:UIButton!){
        calendarView.goBackwardOneMonth()
        updateCalendarView()
    }
}