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
    let todayButton = UIButton()
    var calendarView = CalendarView()
    var forwardMonth = UIButton()
    var backwardMonth = UIButton()
    var dayTable = DayTable(forAutoLayout: ())
    var dayCellHeight = CGFloat()
    
    var currentDaysInView = [NSIndexPath()]
    var dayCellMap = [String:Int]()
    var currentHighlightedButtons = [CalendarViewDateButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayCellMap = calendarManager.fillDateMap()
        
        self.view.addSubview(calendarContainer)
        calendarContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        calendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        calendarContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: CGFloat(calendarContainerHeightMultiplyer))
        calendarContainer.backgroundColor = darkColor
        
        calendarContainer.addSubview(calendarView)
        calendarView.autoCenterInSuperview()
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 0.75)
        
        calendarContainer.addSubview(todayButton)
        todayButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarView)
        todayButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        todayButton.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer)
        todayButton.autoSetDimension(.Height, toSize: 20)
        todayButton.setTitle("Today", forState: .Normal)
        todayButton.addTarget(self, action: #selector(CalendarScrollViewController.todayButtonTap(_:)), forControlEvents: .TouchUpInside)
        
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
        dayTable.separatorColor = UIColor.clearColor()
        dayTable.separatorStyle = .None
        dayTable.separatorEffect = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        dayCellHeight = self.dayTable.frame.height/7
    }
    
    override func viewDidAppear(animated: Bool) {
        let indexPath = NSIndexPath(forItem: dayCellMap[calendarManager.getCurrentDateString()]!, inSection: 0)
        self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        self.updateCalendarView()
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
        
        for dateInContainer in self.calendarView.dateContainers{
            dateInContainer.setViewStatus(CalendarViewDateButton.SelectionStatus.Normal)
        }
        currentHighlightedButtons.removeAll()
        
        for dayInView in self.currentDaysInView{
            if let tableCell = dayTable.cellForRowAtIndexPath(dayInView) as? CalendarScrollCell{
                //make sure there is the correct amount of dateContainers and days
                if calendarView.dateContainers.count >= tableCell.day{
                    let date = calendarView.dateContainers[tableCell.day - 1] //zero based index for day of the month in dateContainers
                    //make sure the day, month, and year are correct for the highlighting
                    if(date.day == tableCell.day && date.month == tableCell.month && date.year == tableCell.year){
                        date.setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentlyDisplayedItem)
                        currentHighlightedButtons.append(date)
                    }
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
            let scrollDirection = dayTable.panGestureRecognizer.velocityInView(dayTable).y
            if scrollDirection != 0{
                dayTable.getScrollDirection(scrollDirection)
            }
            if let indices = dayTable.indexPathsForVisibleRows {
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
        }
        goToTheRightDate()
        self.highlightCurrentDaysInView()
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
                updateCalendarView()
            }else if(cell.day >= 15
                && (cell.month == calendarView.modifiedMonth - 1
                    || cell.year == calendarView.modifiedYear - 1
                    && cell.month == 12)
                && dayTable.dayTableScrollDirection == DayTable.ScrollDirections.Up
                && dayTable.scrolling){
                //calendarView.goBackwardOneMonth()
                calendarView.goToDate(cell.month, day: cell.day, year: cell.year)
                updateCalendarView()
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let dayCell = tableView.dequeueReusableCellWithIdentifier("CalendarScrollCell", forIndexPath: indexPath) as! CalendarScrollCell
    
        if let currentDayRowIndex = self.dayCellMap[calendarManager.getCurrentDateString()]{
            let dateTuple = calendarManager.getDateFromCurrentDateWithOffset(indexPath.row - currentDayRowIndex)
            dayCell.dayDate.text = "\(dateTuple.1)"
            dayCell.month = dateTuple.0
            dayCell.day = dateTuple.1
            dayCell.year = dateTuple.2
            dayCell.dayName.text = calendarManager.getDayString(calendarManager.getDayOfWeek(dayCell.getDate()))

            //do all of the cell stuff asynchronously
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0)) {

                let date = self.calendarManager.makeNSDateFromComponents(dayCell.month, day: dayCell.day, year: dayCell.year)
                let events = self.calendarManager.getEventsForDate(date)
                let alphaValues = self.calendarManager.getAlphaValuesForHours(events)
                
                //dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.5, animations: {
                        for value in 0...23{
                            dayCell.hourHeatMapViews[value].alpha = CGFloat(alphaValues[value])
                        }
                    })
               // }
            //}
            
            
//            dayCell.clearEventViews()
//            
//                let date = calendarManager.makeNSDateFromComponents(dayCell.month, day: dayCell.day, year: dayCell.year)
//                let events = calendarManager.getEventsForDate(date)
//                //var times = [(Double,Double)]()
//                for event in events{
//                    if(!event.allDay){
//                        //times.append((calendarManager.getEventStartTimeForUI(event),calendarManager.getEventEndTimeForUI(event)))
//                        dayCell.addEvent(calendarManager.getEventStartTimeForUI(event), endTime: calendarManager.getEventEndTimeForUI(event))
//                    }
//                }
////                for time in times{
////                    dayCell.addEvent(time.0, endTime: time.1)
////                }
            
            
        }
        
        return dayCell
    }
    
    func goToTheRightDate(){
        if(self.currentHighlightedButtons.count < 7 && self.currentDaysInView.count > 1 && !dayTable.systemScrolling){
            if(self.currentDaysInView.count > 7){
                if let topCellInView = dayTable.cellForRowAtIndexPath(self.currentDaysInView[1]) as? CalendarScrollCell{
                    if(topCellInView.day == 1 || self.currentHighlightedButtons.count == 0){
                        self.calendarView.goToDate(topCellInView.month, day: topCellInView.day, year: topCellInView.year)
                    }
                }
            }else{
                if let topCellInView = dayTable.cellForRowAtIndexPath(self.currentDaysInView[0]) as? CalendarScrollCell{
                    if( topCellInView.day == 1  || self.currentHighlightedButtons.count == 0){
                        self.calendarView.goToDate(topCellInView.month, day: topCellInView.day, year: topCellInView.year)
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        goToTheRightDate()
        self.autoShowCompleteCell(scrollView)
        self.updateCalendarView()
        self.dayTable.scrolling = false
        self.dayTable.systemScrolling = false
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(!decelerate){
            self.autoShowCompleteCell(scrollView)
            goToTheRightDate()
            updateCalendarView()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.dayTable.scrolling = true
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
    
    //CALENDAR FUNCTIONS
    
    func todayButtonTap(sender:UIButton!){
        print("Today tap!")
    }
    
    
    func onDateButtonTap(sender:UIButton!){
        let selectedDate = sender as? CalendarViewDateButton
        if let date = selectedDate{
            //calendarView.currentDayInFocus = date
            print(date.getDate())
            let indexPath = NSIndexPath(forItem: dayCellMap[date.getDate()]!, inSection: 0)
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
        dayTable.systemScrolling = true
    }
    
//    func updateDayTableHeatMap(){
//        for indexPath in self.currentDaysInView{
//            if let dayCell = dayTable.cellForRowAtIndexPath(indexPath) as? CalendarScrollCell{
//                //do all of the cell stuff asynchronously
//                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                    
//                    let date = self.calendarManager.makeNSDateFromComponents(dayCell.month, day: dayCell.day, year: dayCell.year)
//                    let events = self.calendarManager.getEventsForDate(date)
//                    let alphaValues = self.calendarManager.getAlphaValuesForHours(events)
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        //dayCell.resetHeatMap()
//                        UIView.animateWithDuration(1, animations: {
//                            for value in 0...23{
//                                dayCell.hourHeatMapViews[value].alpha = CGFloat(alphaValues[value])
//                            }
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    func updateCalendarView(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            for date in self.calendarView.dateContainers{
                date.addTarget(self, action: #selector(CalendarScrollViewController.onDateButtonTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.highlightCurrentDaysInView()
            }
        }
    }
    
    
//    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//    dispatch_async(dispatch_get_global_queue(priority, 0)) {
//    
//    
//    dispatch_async(dispatch_get_main_queue()) {
//    
//    }
//    }

    func goForwardOneMonth(sender:UIButton!){
        //stop the view from scrolling
        dayTable.setContentOffset(dayTable.contentOffset, animated: false)
        dayTable.scrolling = false
        //if(!dayTable.scrolling){
            dayTable.systemScrolling = true
            dayTable.dayTableScrollDirection = DayTable.ScrollDirections.None
            calendarView.goForwardOneMonth()
            let indexPath = NSIndexPath(forItem: dayCellMap[calendarView.getModifiedDateStartOfMonth()]!, inSection: 0)
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            updateCalendarView()
        //}
    }
    
    func goBackwardOneMonth(sender:UIButton!){
        //stop the view from scrolling
        dayTable.setContentOffset(dayTable.contentOffset, animated: false)
        dayTable.scrolling = false
        //if(!dayTable.scrolling){
            dayTable.systemScrolling = true
            dayTable.dayTableScrollDirection = DayTable.ScrollDirections.None
            calendarView.goBackwardOneMonth()
            let indexPath = NSIndexPath(forItem: dayCellMap[calendarView.getModifiedDateStartOfMonth()]!, inSection: 0)
            self.dayTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            updateCalendarView()
        //}
    }
    
    
    
}