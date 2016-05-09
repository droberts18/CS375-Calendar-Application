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
    
    var dayTable = DayTable(forAutoLayout: ())
    var dayCellHeight = CGFloat()
    var bubbleButton:BubbleButton?
    
    let todayButton = UIButton()
    var forwardMonth = UIButton()
    var backwardMonth = UIButton()
    var calendarView = CalendarView()
    var currentHighlightedButtons = [CalendarViewDateButton]()
    
    var currentDaysInView = [NSIndexPath()]
    var dayCellMap = [String:Int]() //holds the row index for the different dates stored, with key mm-dd-yyyy format
    var cellCache = NSCache() //caches the scrollview cells
    var taskQueue = DeQueue()
    var threadQueue = NSOperationQueue()
    var viewFirstLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.threadQueue.maxConcurrentOperationCount = 7
        dayCellMap = calendarManager.fillDateMap()
        cellCache.countLimit = 120 // cache up to two months worth of data
        cellCache.evictsObjectsWithDiscardedContent = true
        
        self.view.addSubview(calendarContainer)
        self.calendarContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        self.calendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        self.calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        self.calendarContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: CGFloat(calendarContainerHeightMultiplyer))
        self.calendarContainer.backgroundColor = darkColor
        
        self.calendarContainer.addSubview(calendarView)
        self.calendarView.autoCenterInSuperview()
        self.calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 0.75)
        
        self.calendarContainer.addSubview(todayButton)
        self.todayButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarView)
        self.todayButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        self.todayButton.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer)
        self.todayButton.autoSetDimension(.Height, toSize: 20)
        self.todayButton.setTitle("Today", forState: .Normal)
        self.todayButton.addTarget(self, action: #selector(CalendarScrollViewController.todayButtonTap(_:)), forControlEvents: .TouchUpInside)
        
        //SIDE BUTTONS
        let rightSide = UIView()
        self.calendarContainer.addSubview(rightSide)
        rightSide.autoPinEdge(.Left, toEdge: .Right, ofView: calendarView)
        rightSide.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        rightSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        rightSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        rightSide.addSubview(forwardMonth)
        self.forwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: rightSide, withMultiplier: 1)
        self.forwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: rightSide, withMultiplier: 1)
        self.forwardMonth.autoCenterInSuperview()
        let forwardImage = UIImage(named: "ForwardButton.png")
        let forwardButtonImageView = UIImageView(image: forwardImage)
        self.forwardMonth.addSubview(forwardButtonImageView)
        forwardButtonImageView.autoCenterInSuperview()
        forwardButtonImageView.alpha = 0.25
        self.forwardMonth.addTarget(self, action: #selector(CalendarScrollViewController.goForwardOneMonth(_:)), forControlEvents: .TouchUpInside)
        let leftSide = UIView()
        self.calendarContainer.addSubview(leftSide)
        leftSide.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView)
        leftSide.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer)
        leftSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        leftSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        leftSide.addSubview(backwardMonth)
        self.backwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: leftSide, withMultiplier: 1)
        self.backwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: leftSide, withMultiplier: 1)
        self.backwardMonth.autoCenterInSuperview()
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
        dayTable.separatorColor = UIColor.clearColor()
        dayTable.separatorStyle = .None
        dayTable.separatorEffect = .None
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            for date in self.calendarView.dateContainers{
                date.addTarget(self, action: #selector(CalendarScrollViewController.onDateButtonTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.highlightCurrentDaysInView()
            }
        }
        
        self.bubbleButton = BubbleButton(buttonColor: blueColor, imageFileName: "AddEventButtonPlus.png", identifier: "Menu")
        self.view.addSubview(bubbleButton!)
        self.bubbleButton?.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -7)
        self.bubbleButton?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -7)
        //self.bubbleButton?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: (self.bubbleButton?.navButtonSize)!/2)
        
        
        bubbleButton?.addNavButton(greenColor, imageFileName: "AddLocation.png")
        bubbleButton?.addNavButton(blueColor, imageFileName: "AddLocation.png")
        bubbleButton?.addNavButton(darkColor, imageFileName: "AddLocation.png")
//        bubbleButton?.addNavButton(lightDarkColor, imageFileName: "AddLocation.png")
//        bubbleButton?.addNavButton(whiteColor, imageFileName: "AddLocation.png")

        
        bubbleButton?.navButtons[0].0.addTarget(self, action: #selector(CalendarScrollViewController.addLocation(_:)), forControlEvents: .TouchUpInside)
        bubbleButton?.navButtons[1].0.addTarget(self, action: #selector(CalendarScrollViewController.addEvent(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        dayCellHeight = self.dayTable.frame.height/7
        if let indices = dayTable.indexPathsForVisibleRows {
            self.currentDaysInView.removeAll()
            self.currentDaysInView = indices
            self.highlightCurrentDaysInView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.viewFirstLoaded{
            let indexPath = NSIndexPath(forItem: dayCellMap[calendarManager.getCurrentDateString()]!, inSection: 0)
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            self.viewFirstLoaded = false
        }
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
    
    func highlightCurrentDaysInView(){
        
        for highlightedButton in self.currentHighlightedButtons{
            if(highlightedButton.status != CalendarViewDateButton.SelectionStatus.PrevMonth
                && highlightedButton.status != CalendarViewDateButton.SelectionStatus.NextMonth
                && highlightedButton.status != CalendarViewDateButton.SelectionStatus.CurrentDay){
                
                highlightedButton.setViewStatus(CalendarViewDateButton.SelectionStatus.Normal)
            }
        }
        
        currentHighlightedButtons.removeAll()
        
        if let indices = dayTable.indexPathsForVisibleRows {
            self.currentDaysInView.removeAll()
            self.currentDaysInView = indices
        
        
            for dayInView in self.currentDaysInView{
                if let tableCell = dayTable.cellForRowAtIndexPath(dayInView) as? CalendarScrollCell{
                    let startDay = calendarView.getStartDayInMonth(calendarView.modifiedMonth, year: calendarView.modifiedYear)
                    let date = calendarView.dateContainers[startDay + tableCell.day - 1] //zero based index for day of the month in dateContainers
                    if(tableCell.day == date.day && tableCell.month == date.month && tableCell.year == date.year){
                        date.setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentlyDisplayedItem)
                        self.currentHighlightedButtons.append(date)
                    }
                }
            }
            
            //make sure the right amount of cells are highlighted
            if(self.currentDaysInView.count > 7
                && self.currentHighlightedButtons.count > 0
                && self.currentHighlightedButtons.last?.day > 15
                || self.currentHighlightedButtons.count > 7){
                    self.currentHighlightedButtons[0].setViewStatus(CalendarViewDateButton.SelectionStatus.Normal)
                    self.currentHighlightedButtons.removeFirst()
            }
        }
        
    }
    
    func changeMonthBasedOnScrollDirectionAndTopCell(cell: CalendarScrollCell){
        if(cell.day < 15
            && (cell.month == calendarView.modifiedMonth + 1
                || cell.year == calendarView.modifiedYear + 1
                && cell.month == 1)
            && dayTable.dayTableScrollDirection == DayTable.ScrollDirections.Down
            && dayTable.scrolling){
            //calendarView.goForwardOneMonth()
            calendarView.goToDate(cell.month, day: cell.day, year: cell.year)
            //updateCalendarView()
        }else if(cell.day >= 15
            && (cell.month == calendarView.modifiedMonth - 1
                || cell.year == calendarView.modifiedYear - 1
                && cell.month == 12)
            && dayTable.dayTableScrollDirection == DayTable.ScrollDirections.Up
            && dayTable.scrolling){
            //calendarView.goBackwardOneMonth()
            calendarView.goToDate(cell.month, day: cell.day, year: cell.year)
            //updateCalendarView()
        }
    }
    
    func goToTheRightDate(){
        if(self.currentHighlightedButtons.count < 7 && self.currentDaysInView.count > 1){
            if(self.currentDaysInView.count > 7){
                if let topCellInView = dayTable.cellForRowAtIndexPath(self.currentDaysInView[1]) as? CalendarScrollCell{
                    if(topCellInView.day == 1 || self.currentHighlightedButtons.count == 0 || topCellInView.month != calendarView.modifiedMonth){
                        self.calendarView.goToDate(topCellInView.month, day: topCellInView.day, year: topCellInView.year)
                    }
                }
            }else{
                if let topCellInView = dayTable.cellForRowAtIndexPath(self.currentDaysInView[0]) as? CalendarScrollCell{
                    if( topCellInView.day == 1  || self.currentHighlightedButtons.count == 0 || topCellInView.month != calendarView.modifiedMonth){
                        self.calendarView.goToDate(topCellInView.month, day: topCellInView.day, year: topCellInView.year)
                    }
                }
            }
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
        self.highlightCurrentDaysInView()
    }
    
    //TABLE VIEW FUNCTIONS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.calendarManager.numberOfDaysLoaded
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
            let scrollDirection = dayTable.panGestureRecognizer.velocityInView(dayTable).y
            if scrollDirection != 0{
                dayTable.getScrollDirection(scrollDirection)
            }
            if let indices = dayTable.indexPathsForVisibleRows {
                self.currentDaysInView.removeAll()
                self.currentDaysInView = indices
            }
            if(self.currentHighlightedButtons.count < 7 || self.currentHighlightedButtons.count == 0){
                if(self.currentHighlightedButtons.count < 7 || self.currentDaysInView.count > 7){
                    if let cell = dayTable.cellForRowAtIndexPath(self.currentDaysInView[0]) as? CalendarScrollCell{
                        self.changeMonthBasedOnScrollDirectionAndTopCell(cell)
                    }
                }else if (self.currentDaysInView.count <= 7 && (self.currentHighlightedButtons.count < 7 || self.currentDaysInView.count > 0)){
                    if let cell = dayTable.cellForRowAtIndexPath(self.currentDaysInView.first!) as? CalendarScrollCell{
                        self.changeMonthBasedOnScrollDirectionAndTopCell(cell)
                    }
                }
            }
        self.goToTheRightDate()
        self.highlightCurrentDaysInView()
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dayCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var taskToExecute:()->()
        var dayCell:CalendarScrollCell?
        if let cell = self.cellCache.objectForKey(indexPath){
            dayCell = (cell as? CalendarScrollCell)!
            
            taskToExecute = { () -> Void in
                let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
                let events = self.calendarManager.getEventsForDate(date)
                dayCell!.colorValues?.removeAll()
                dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.5, animations: {
                        if(!(dayCell!.addedViews)){
                            dayCell!.setHeatMap()
                        }
                        dayCell!.updateHeatMap()
                    })
                }
            }
            if self.threadQueue.operationCount > 20{
                self.threadQueue.cancelAllOperations()
            }
            self.threadQueue.addOperationWithBlock(taskToExecute)
//            self.taskQueue.pushFront(taskToExecute)
        }else{
            dayCell = CalendarScrollCell()
            self.cellCache.setObject(dayCell!, forKey: indexPath)
            
            taskToExecute = { () -> Void in
                let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
                let events = self.calendarManager.getEventsForDate(date)
                dayCell!.colorValues?.removeAll()
                dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.5, animations: {
                        dayCell!.setHeatMap()
                    })
                }
            }
            if self.threadQueue.operationCount > 20{
                self.threadQueue.cancelAllOperations()
            }
            self.threadQueue.addOperationWithBlock(taskToExecute)
//            self.taskQueue.pushFront(taskToExecute)
        }
        
        
//        while self.taskQueue.count > 7{
//            self.taskQueue.popBack()
//            self.threadQueue.cancelAllOperations()
//        }
//        let myTask = self.taskQueue.popFront() as? ()->()
//        threadQueue.addOperationWithBlock(myTask!)
        
        
        //Second method-----------------------------------------------------------------------------------------------------------------------------------------
//        typealias BlockType = () -> ()
//        //var dayCell:CalendarScrollCell?
//        var taskToExecute:BlockType? //block of code to be executed later
//        if let cell = self.cellCache.objectForKey(indexPath){
//            dayCell = (cell as? CalendarScrollCell)!
//            taskToExecute = {
//                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                    let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
//                    let events = self.calendarManager.getEventsForDate(date)
//                    dayCell!.colorValues?.removeAll()
//                    dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
//                    dispatch_async(dispatch_get_main_queue()) {
//                        UIView.animateWithDuration(0.5, animations: {
//                            if(!(dayCell!.addedViews)){
//                                dayCell!.setHeatMap()
//                            }
//                            dayCell!.updateHeatMap()
//                        })
//                    }
//                }
//            }
//        }else{
//            
//            //create a new cell if the cell has not been cached
//            dayCell = CalendarScrollCell()
//            self.cellCache.setObject(dayCell!, forKey: indexPath)
//            taskToExecute = {
//                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                    let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
//                    let events = self.calendarManager.getEventsForDate(date)
//                    dayCell!.colorValues?.removeAll()
//                    dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
//                    dispatch_async(dispatch_get_main_queue()) {
//                        UIView.animateWithDuration(0.5, animations: {
//                            dayCell!.setHeatMap()
//                        })
//                    }
//                }
//            }
//        }
//        
//        taskQueue.pushFront(taskToExecute)
//        if self.taskQueue.count > 7{
//            self.taskQueue.popBack()
//        }
//
//        while self.taskQueue.count > 0{
//            let block = self.taskQueue.popFront() as? BlockType
//            block!()
//        }

//First method-----------------------------------------------------------------------------------------------------------------------------------------
        
        
//        let dayCell:CalendarScrollCell?
//        if let cell = self.cellCache.objectForKey(indexPath){
//            dayCell = cell as? CalendarScrollCell
//            if(!(dayCell?.addedViews)!){
//                dayCell?.setHeatMap()
//            }
//            
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                
//                var okToComplete = false
//                dispatch_sync(dispatch_get_main_queue(), { 
//                    if self.currentDaysInView.contains(indexPath){
//                        okToComplete = true
//                    }
//                })
//                
//                if(okToComplete){
//                    let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
//                    let events = self.calendarManager.getEventsForDate(date)
//                    dayCell!.colorValues?.removeAll()
//                    dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        UIView.animateWithDuration(0.5, animations: {
//                            dayCell!.updateHeatMap()
//                        })
//                    }
//                }
//            }
//        }else{
//            dayCell = CalendarScrollCell()
//            //self.scrollCellMap[indexPath] = dayCell
//            self.cellCache.setObject(dayCell!, forKey: indexPath)
//            
//            //do all of the cell stuff asynchronously
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                
//                let date = self.calendarManager.makeNSDateFromComponents(dayCell!.month, day: dayCell!.day, year: dayCell!.year)
//                let events = self.calendarManager.getEventsForDate(date)
//                dayCell!.colorValues?.removeAll()
//                dayCell!.colorValues = self.calendarManager.getColorValuesForHours(events)
//
//                dispatch_async(dispatch_get_main_queue()) {
//                    UIView.animateWithDuration(0.5, animations: {
//                        dayCell!.setHeatMap()
//                    })
//                }
//            }
//        }
        
        let currentDayRowIndex = self.dayCellMap[self.calendarManager.getCurrentDateString()]
        let dateTuple = self.calendarManager.getDateFromCurrentDateWithOffset(indexPath.row - currentDayRowIndex!)
        dayCell!.dayDate.text = "\(dateTuple.1)"
        dayCell!.month = dateTuple.0
        dayCell!.day = dateTuple.1
        dayCell!.year = dateTuple.2
        let dayName = self.calendarManager.getDayString(self.calendarManager.getDayOfWeek(dayCell!.getDate()))
        dayCell!.dayName.text = dayName

        return dayCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dayCell = tableView.cellForRowAtIndexPath(indexPath) as? CalendarScrollCell

        UIView.animateWithDuration(0.5, animations: {
            dayCell?.cellWasSelected()
        }) { (value:Bool) in
            self.presentViewController(DayEventsViewController(), animated: true, completion: {})
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        self.autoShowCompleteCell(scrollView)
        self.dayTable.scrolling = false
        self.dayTable.systemScrolling = false
        goToTheRightDate()
        highlightCurrentDaysInView()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(!decelerate){
            self.autoShowCompleteCell(scrollView)
        }
        //goToTheRightDate()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.dayTable.scrolling = true
    }
    //END TABLE VIEW FUNCTIONS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //CALENDAR FUNCTIONS
    
    func todayButtonTap(sender:UIButton!){
        dayTable.setContentOffset(dayTable.contentOffset, animated: false)
        let indexPath = NSIndexPath(forItem: dayCellMap[calendarManager.getCurrentDateString()]!, inSection: 0)
        
        if(self.currentHighlightedButtons.count > 0 && self.currentHighlightedButtons.first?.month == calendarManager.currentMonth
            && self.currentHighlightedButtons.first?.year == calendarManager.currentYear){
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }else{
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            self.calendarView.goToDate(calendarManager.currentMonth, day: calendarManager.currentDay, year: calendarManager.currentYear)
        }
        
    }
    
    
    func onDateButtonTap(sender:UIButton!){
        if let date = sender as? CalendarViewDateButton{
            print(date.getDate())
            let indexPath = NSIndexPath(forItem: dayCellMap[date.getDate()]!, inSection: 0)
            
            if(date.status != CalendarViewDateButton.SelectionStatus.PrevMonth
                && date.status != CalendarViewDateButton.SelectionStatus.NextMonth){
                self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            }else{
                self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
            
            if(date.status == CalendarViewDateButton.SelectionStatus.PrevMonth){
                self.calendarView.goToDate(date.month, day: date.day, year: date.year)
            }else if(date.status == CalendarViewDateButton.SelectionStatus.NextMonth){
                self.calendarView.goToDate(date.month, day: date.day, year: date.year)
            }
        }
        dayTable.systemScrolling = true
    }

    func goForwardOneMonth(sender:UIButton!){
        dayTable.setContentOffset(dayTable.contentOffset, animated: false) //stop any previous scrolling actions
        dayTable.dayTableScrollDirection = DayTable.ScrollDirections.None //set scroll action to none so it doesn't confuse the auto-alignment of cells
        calendarView.incrementOneMonth()    //increment the modified month
        calendarView.goToDate(calendarView.modifiedMonth, day: calendarView.modifiedDay, year: calendarView.modifiedYear)   //update the calendar view
        let indexPath = NSIndexPath(forItem: dayCellMap[calendarView.getModifiedDateStartOfMonth()]!, inSection: 0)         //create the index path
        self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)                            //go to the right cell
        self.dayTable.systemScrolling = false
        self.highlightCurrentDaysInView()                                                                                   //highlight the right cells
    }
    
    func goBackwardOneMonth(sender:UIButton!){
        dayTable.setContentOffset(dayTable.contentOffset, animated: false)
        dayTable.dayTableScrollDirection = DayTable.ScrollDirections.None
        calendarView.decrementOneMonth()
        calendarView.goToDate(calendarView.modifiedMonth, day: calendarView.modifiedDay, year: calendarView.modifiedYear)
        let indexPath = NSIndexPath(forItem: dayCellMap[calendarView.getModifiedDateStartOfMonth()]!, inSection: 0)
        self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        dayTable.systemScrolling = false
    }
    
    func addLocation(sender: UIButton!){
        self.presentViewController(AddLocationViewController(), animated: true, completion: {})
    }
    
    func addEvent(sender: UIButton!){
        self.presentViewController(AddEventViewController(), animated: true, completion: {})
    }
}