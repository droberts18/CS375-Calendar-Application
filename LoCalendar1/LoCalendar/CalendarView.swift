//
//  CalendarView.swift
//  
//
//  Created by Tyler Reardon on 4/14/16.
//
//

import Foundation

class CalendarView: UIView{
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    var monthName = String()
    var dayNames:[String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var daysInMonth = Int()
    let dayHeight:CGFloat = 30.0
    
    var monthLabel = UILabel()
    var yearLabel = UILabel()
    var dayLabels:[UILabel] = []
    var dateContainers: [CalendarViewDateButton] = []
    var daysInView: [CalendarViewDateButton] = []
    
    var currentDay = Int()
    var currentMonth = Int()
    var currentYear = Int()
    
    var modifiedDay = Int()
    var modifiedMonth = Int()
    var modifiedYear = Int()
    
    let calendarContainer = UIView()
    //let todayButton = UIButton()
    
    convenience init(){
        self.init(frame: CGRect.zero)
    
        //set month day label
        self.addSubview(monthLabel)
        monthLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        monthLabel.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        monthLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 1/8)
        monthLabel.textColor = UIColor.whiteColor()
        monthLabel.textAlignment = .Right
        monthLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        monthLabel.textColor = greenColor
        
        self.addSubview(yearLabel)
        yearLabel.autoPinEdge(.Top, toEdge: .Top, ofView: monthLabel)
        yearLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 1/8)
        yearLabel.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        yearLabel.textColor = UIColor.whiteColor()
        yearLabel.textAlignment = .Left
        
        //set days of the week
        for day in dayNames{
            let dayName = UILabel()
            dayName.text = day
            dayLabels.append(dayName)
        }
        
        self.addSubview(calendarContainer)
        calendarContainer.autoPinEdgeToSuperviewEdge(.Left)
        calendarContainer.autoPinEdgeToSuperviewEdge(.Right)
        calendarContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthLabel)
        calendarContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        
        var prevDayOfWeek:UIView?
        var first = true
        for day in dayLabels{
            
            day.textAlignment = .Center
            day.font = day.font.fontWithSize(12)
            day.textColor = UIColor.whiteColor()
            
            calendarContainer.addSubview(day)
            day.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthLabel)
            day.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 1/7)
            day.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarContainer, withMultiplier: 1/9)
            if first{
                day.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer)
                first = false
            }else{
                day.autoPinEdge(.Left, toEdge: .Right, ofView: prevDayOfWeek!)
            }
            prevDayOfWeek = day
        }
        
        
        first = true
        var currentDayOfWeek = 0
        var prevDate:CalendarViewDateButton?
        for _ in 0...41{
            let dayButton = CalendarViewDateButton()
            dateContainers.append(dayButton)
            calendarContainer.addSubview(dayButton)
            dayButton.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarContainer, withMultiplier: 1/7)
            dayButton.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 1/7)
            
            if first{
                dayButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: dayLabels[0])
                dayButton.autoPinEdge(.Left, toEdge: .Left, ofView: dayLabels[0])
                first = false
            }else if currentDayOfWeek > 0{
                dayButton.autoPinEdge(.Top, toEdge: .Top, ofView: prevDate!)
                dayButton.autoPinEdge(.Left, toEdge: .Right, ofView: prevDate!)
            }else if currentDayOfWeek == 0{
                dayButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: prevDate!)
                dayButton.autoPinEdge(.Left, toEdge: .Left, ofView: dayLabels[0])
            }
            
            if currentDayOfWeek == 6{
                currentDayOfWeek = 0
            }else{
                currentDayOfWeek += 1
            }
            prevDate = dayButton
        }
        
//        self.addSubview(todayButton)
//        todayButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
//        todayButton.autoPinEdge(.Right, toEdge: .Right, ofView: self)
//        todayButton.autoPinEdge(.Left, toEdge: .Left, ofView: self)
//        todayButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarContainer)
//        todayButton.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 1/8)
//        todayButton.setTitle("Today", forState: .Normal)
//        todayButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        //todayButton.titleLabel?.font = UIFont(name: "Helvetica", size: 10)
        
        updateCurrentInfo()
        self.modifiedDay = self.currentDay
        self.modifiedMonth = self.currentMonth
        self.modifiedYear = self.currentYear
        
        self.setMonth(self.currentMonth)
        self.setYear(self.currentYear)
//        self.setDaysInMonth(self.getNumDaysInMonth(self.currentMonth, year: self.currentYear), startDay: self.getStartDayInMonth(self.currentMonth, year: self.currentYear))
        
        self.updateMonth(self.currentMonth, year: self.currentYear)
    }
    
    
    func updateMonth(month:Int, year:Int){
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {

            self.updateCurrentInfo()
            
            let prevMonthAndYear = self.getPrevMonthAndYearNumber(month, year: year)
            let numDaysInPrevMonth = self.getNumDaysInMonth(prevMonthAndYear.0, year: prevMonthAndYear.1)
            
            let nextMonthAndYear = self.getNextMonthAndYearNumber(month, year: year)
            
            let numDaysInCurrentMonth = self.getNumDaysInMonth(month, year: year)
            let startDay = self.getStartDayInMonth(month, year: year)
            
            dispatch_async(dispatch_get_main_queue()) {

                //FOR PREVIOUS MONTH'S DAYS
                if(startDay != 0){
                    var day = startDay - 1
                    var difference = 0
                    while(day >= 0){
                        self.dateContainers[day].setDate(prevMonthAndYear.0, day: numDaysInPrevMonth - difference, year: prevMonthAndYear.1)
                        if(self.dateContainers[day].getDate() == self.getCurrentDate()){
                            self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentDay)
                            self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.PrevMonth)
                        }else{
                            self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.DeselectCurrentDay)
                            self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.PrevMonth)
                        }
                        day -= 1
                        difference += 1
                    }
                }
                
                //FOR CURRENT MONTH'S DAYS
                var date = 1
                for day in startDay...numDaysInCurrentMonth + startDay - 1{
                    self.dateContainers[day].setDate(month, day: date, year: year)
                    if(self.dateContainers[day].getDate() == self.getCurrentDate()){
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentDay)
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentlyDisplayedItem)
                    }else{
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.DeselectCurrentDay)
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.Normal)
                    }
                    date += 1
                }
                
                
                //FOR NEXT MONTH'S DAYS
                date = 1
                for day in numDaysInCurrentMonth + startDay...self.dateContainers.count - 1{
                    self.dateContainers[day].setDate(nextMonthAndYear.0, day: date, year: nextMonthAndYear.1)
                    if(self.dateContainers[day].getDate() == self.getCurrentDate()){
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentDay)
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.NextMonth)
                    }else{
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.DeselectCurrentDay)
                        self.dateContainers[day].setViewStatus(CalendarViewDateButton.SelectionStatus.NextMonth)
                    }
                    date += 1
                }
            }
        }
    }
    
    
    //returns the next valid month and year
    func getNextMonthAndYearNumber(month:Int,year:Int) -> (Int,Int){
        if(month <= 0 || month > 12){
            return (-1,-1) //error
        }
        if(month == 12){
            return (1,year + 1)
        }else{
            return (month + 1, year)
        }
    }
    
    //returns the previous valid month and year
    func getPrevMonthAndYearNumber(month:Int,year:Int) -> (Int,Int){
        if(month <= 0 || month > 12){
            return (-1,-1) //error
        }
        if(month == 1){
            return (12, year - 1)
        }else{
            return (month - 1, year)
        }
    }
    
//    func calendarDayDidChange(notification : NSNotification)
//    {
//        if(self.modifiedMonth == self.currentMonth && self.modifiedYear == self.currentYear){
//            self.dateContainers[self.currentDay].setViewStatus(CalendarViewDateButton.SelectionStatus.DeselectCurrentDay)
//        }
//        let numDaysInMonth = self.getNumDaysInMonth(self.currentMonth, year: self.currentYear)
//        //if it's the last day in the month, update the current values
//        if(self.currentDay == numDaysInMonth){
//            self.currentDay = 1
//            if(self.currentMonth == 12){
//                self.currentMonth = 1
//                self.currentYear += 1
//            }else{
//                self.currentMonth += 1
//            }
//        }else{
//            self.currentDay += 1
//        }
//        
//        if(self.modifiedMonth == self.currentMonth && self.modifiedYear == self.currentYear){
//            self.dateContainers[self.currentDay].setViewStatus(CalendarViewDateButton.SelectionStatus.CurrentDay)
//        }
//    }
    
    func setMonth(monthNumber:Int){
        switch monthNumber{
        case 1:
            self.monthLabel.text = "JANUARY"
            break
        case 2:
            self.monthLabel.text = "FEBRUARY"
            break
        case 3:
            self.monthLabel.text = "MARCH"
            break
        case 4:
            self.monthLabel.text = "APRIL"
            break
        case 5:
            self.monthLabel.text = "MAY"
            break
        case 6:
            self.monthLabel.text = "JUNE"
            break
        case 7:
            self.monthLabel.text = "JULY"
            break
        case 8:
            self.monthLabel.text = "AUGUST"
            break
        case 9:
            self.monthLabel.text = "SEPTEMBER"
            break
        case 10:
            self.monthLabel.text = "OCTOBER"
            break
        case 11:
            self.monthLabel.text = "NOVEMBER"
            break
        case 12:
            self.monthLabel.text = "DECEMBER"
            break
        default:
            self.monthLabel.text = "err"
            break
        }
    }
    
    func setYear(year: Int){
        self.yearLabel.text = "\(year)"
    }
    
    
    func getNumDaysInMonth(month:Int, year:Int) -> Int{
        if(month < 1 || month > 12){
            return 0
        }
        
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(dateComponents)!
        
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        let numDays = range.length
        return numDays
    }
    
    func getStartDayInMonth(month:Int, year:Int) -> Int{
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(dateComponents)!
        
        let components:NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
        components.setValue(1, forComponent: .Day)
        let firstDayOfMonthDate = calendar.dateFromComponents(components)
        
        let myComponents = calendar.components(.Weekday, fromDate: firstDayOfMonthDate!)
        let weekDay = myComponents.weekday
        
        return weekDay - 1 //to make zero based
    }
    
    //gets current day, month, and year and updates the corresponding variables
    func updateCurrentInfo(){
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        self.currentDay = (calendar?.component(NSCalendarUnit.Day, fromDate: NSDate()))!
        self.currentMonth = (calendar?.component(NSCalendarUnit.Month, fromDate: NSDate()))!
        self.currentYear = (calendar?.component(NSCalendarUnit.Year, fromDate: NSDate()))!
    }
    
    
    func getCurrentDate() -> String{
        return "\(self.currentMonth)-\(self.currentDay)-\(self.currentYear)"
    }
    
    func getModifiedDate() -> String{
        return "\(self.modifiedMonth)-\(self.modifiedDay)-\(self.modifiedYear)"
    }
    
    func getModifiedDateStartOfMonth() -> String{
        return "\(self.modifiedMonth)-1-\(self.modifiedYear)"
    }
    
    func goToDate(month: Int, day: Int, year: Int){
        self.modifiedMonth = month
        self.modifiedDay = day
        self.modifiedYear = year
        
//        let numDays = self.getNumDaysInMonth(self.modifiedMonth, year: self.modifiedYear)
//        let startDay = self.getStartDayInMonth(self.modifiedMonth, year: self.modifiedYear)
        //self.setDaysInMonth(numDays, startDay: startDay)
        self.updateMonth(month, year: year)
        self.setMonth(self.modifiedMonth)
        self.setYear(self.modifiedYear)
        self.setNeedsLayout()
    }
    
    func goForwardOneMonth(){
        if(self.modifiedMonth < 12){
            self.modifiedMonth += 1
        }else{
            self.modifiedMonth = 1
            self.modifiedYear += 1
        }
//        let numDays = self.getNumDaysInMonth(self.modifiedMonth, year: self.modifiedYear)
//        let startDay = self.getStartDayInMonth(self.modifiedMonth, year: self.modifiedYear)
        //self.setDaysInMonth(numDays, startDay: startDay)
        self.updateMonth(self.modifiedMonth, year: self.modifiedYear)
        self.setMonth(self.modifiedMonth)
        self.setYear(self.modifiedYear)
        self.setNeedsLayout()
        //self.layoutIfNeeded()
    }
    
    func goBackwardOneMonth(){
        if(self.modifiedMonth > 1){
            self.modifiedMonth -= 1
        }else{
            self.modifiedMonth = 12
            self.modifiedYear -= 1
        }
//        let numDays = self.getNumDaysInMonth(self.modifiedMonth, year: self.modifiedYear)
//        let startDay = self.getStartDayInMonth(self.modifiedMonth, year: self.modifiedYear)
        //self.setDaysInMonth(numDays, startDay: startDay)
        self.updateMonth(self.modifiedMonth, year: self.modifiedYear)
        self.setMonth(self.modifiedMonth)
        self.setYear(self.modifiedYear)
        self.setNeedsLayout()
        //self.layoutIfNeeded()
    }
}