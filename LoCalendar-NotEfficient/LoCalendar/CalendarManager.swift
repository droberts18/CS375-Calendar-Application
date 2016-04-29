//
//  CalendarManager.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/18/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    
    let eventStore = EKEventStore()
    let calendar = NSCalendar.currentCalendar()
    //var eventDictionary = [String:[EKEvent]]()
    var authorized = false
    var numberOfDaysLoaded = Int()
    
    var currentDay = Int()
    var currentMonth = Int()
    var currentYear = Int()
    
    var firstDayLoaded = Int()
    var firstMonthLoaded = Int()
    var firstYearLoaded = Int()
    
    var lastDayLoaded = Int()
    var lastMonthLoaded = Int()
    var lastYearLoaded = Int()
    
    init(){
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        self.currentDay = (calendar?.component(NSCalendarUnit.Day, fromDate: NSDate()))!
        self.currentMonth = (calendar?.component(NSCalendarUnit.Month, fromDate: NSDate()))!
        self.currentYear = (calendar?.component(NSCalendarUnit.Year, fromDate: NSDate()))!
        
        self.firstDayLoaded = self.currentDay
        self.firstMonthLoaded = self.currentMonth
        self.firstYearLoaded = self.currentYear
        
        self.lastDayLoaded = self.currentDay
        self.lastMonthLoaded = self.currentMonth
        self.lastYearLoaded = self.currentYear
        
        numberOfDaysLoaded = getNumDaysInYear(self.currentYear) + getNumDaysInYear(self.currentYear - 1)
        checkStatus()
        
//        var today = NSDate()
//        self.getEventsForDate(today)
        
        fillDateMap()
    }
    
    func fillDateMap() -> [String:Int]{
        var dateMap = [String:Int]()
        var rowIndex = 0
        for myYear in self.currentYear-30...self.currentYear+30{
            for myMonth in 1...12{
                for myDay in 1...self.getNumDaysInMonth(myMonth, year: myYear){
                    dateMap["\(myMonth)-\(myDay)-\(myYear)"] = rowIndex
                    rowIndex += 1
                }
            }
        }
        numberOfDaysLoaded = dateMap.count
        return dateMap
    }
    
    func checkStatus(){
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: {_,_ in
                print("has access")
                if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) == EKAuthorizationStatus.Authorized{
                    self.authorized = true
                }
            })
            break
        case EKAuthorizationStatus.Authorized:
            print("Authorized")
            self.authorized = true
            break
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            print("Denied")
            eventStore.requestAccessToEntityType(.Event, completion: {_,_ in print("")})
            break
        }
    }
    
    func makeNSDateFromComponents(month:Int, day:Int, year:Int) -> NSDate{
        let newDateComponents = NSDateComponents()
        newDateComponents.day = day
        newDateComponents.month = month
        newDateComponents.year = year
        let newDate = NSCalendar.currentCalendar().dateFromComponents(newDateComponents)
        return newDate!
    }
    
    func getEventsForDate(date: NSDate) -> [EKEvent]{
        
        let beginningOfDay = calendar.startOfDayForDate(date)
        
        var endOfDay: NSDate? {
            let components = NSDateComponents()
            components.day = 1
            components.second = -1
            return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: beginningOfDay, options: NSCalendarOptions())
        }
        
//        var titles : [String] = []
//        var startDates : [NSDate] = []
//        var endDates : [NSDate] = []
        
//        let eventStore = EKEventStore()
        let calendars = eventStore.calendarsForEntityType(.Event)
        
        var myEvents = [EKEvent]()
        
        for calendar in calendars {
            //if calendar.title == "Work" {
            
            let myPredicate = eventStore.predicateForEventsWithStartDate(beginningOfDay, endDate: endOfDay!, calendars: [calendar])
            let events = eventStore.eventsMatchingPredicate(myPredicate)
                for event in events {
                    //print(event.title)
                    //print(getFormattedEventStartTime(event))
//                    titles.append(event.title)
//                    startDates.append(event.startDate)
//                    endDates.append(event.endDate)
                    myEvents.append(event)
                }
            //}
        }
        return myEvents
    }
    
    func getEventStartTimeForUI(event: EKEvent) -> Double{
        let timestamp = NSDateFormatter.localizedStringFromDate(event.startDate, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        let timeComponents = timestamp.componentsSeparatedByString(" ")
        let time = timeComponents[0].componentsSeparatedByString(":")
        
        var timeNumber:Double = 0
        
        //get the initial hour
        timeNumber = Double(time[0])!
        if(timeComponents[1] == "PM" && timeNumber < 12){
            timeNumber += 12
        }else if(timeComponents[1] == "AM" && time[0] == "12"){
            timeNumber = 0
        }
        //get the fraction of the hour
        timeNumber += (Double(time[1])!/60)
        
        return timeNumber
    }
    
    func getEventEndTimeForUI(event: EKEvent) -> Double{
        let timestamp = NSDateFormatter.localizedStringFromDate(event.endDate, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        let timeComponents = timestamp.componentsSeparatedByString(" ")
        let time = timeComponents[0].componentsSeparatedByString(":")
        
        var timeNumber:Double = 0
        
        //get the initial hour
        timeNumber = Double(time[0])!
        if(timeComponents[1] == "PM" && timeNumber < 12){
            timeNumber += 12
        }
        //get the fraction of the hour
        timeNumber += (Double(time[1])!/60)
        
        return timeNumber
    }
    
    func getFormattedEventStartTime(event: EKEvent) -> String{
        let timestamp = NSDateFormatter.localizedStringFromDate(event.startDate, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        let timePieces = timestamp.componentsSeparatedByString(" ")
        
        if(timePieces.count == 2){
            if(timePieces[1] == "AM"){
                return "\(timePieces[0])am"
            }else{
                return "\(timePieces[0])pm"
            }
        }
        return timestamp
    }
    
    func getFormattedEventEndTime(event: EKEvent) -> String{
        let timestamp = NSDateFormatter.localizedStringFromDate(event.endDate, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        let timePieces = timestamp.componentsSeparatedByString(" ")
        
        if(timePieces.count == 2){
            if(timePieces[1] == "AM"){
                return "\(timePieces[0])am"
            }else{
                return "\(timePieces[0])pm"
            }
        }
        return timestamp
    }
    
    func getDateString(date: NSDate) -> String{
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return "\(month)-\(day)-\(year)"
    }
    
    func getDateString(month:Int,day:Int,year:Int) -> String{
        return "\(month)-\(day)-\(year)"
    }
    
    func getCurrentDateString() -> String{
        return getDateString(self.currentMonth, day: self.currentDay, year: self.currentYear)
    }
    
    func getDateFromCurrentDateWithOffset(offset:Int) -> (Int,Int,Int){
        let newDateComponents = NSDateComponents()
        newDateComponents.day = self.currentDay + offset
        newDateComponents.month = self.currentMonth
        newDateComponents.year = self.currentYear
        let newDate = NSCalendar.currentCalendar().dateFromComponents(newDateComponents)
        
        if let date = newDate{
            let newComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
            let day = newComponents.day
            let month = newComponents.month
            let year = newComponents.year
            let dateTuple = (month, day, year)
            return dateTuple
        }
        return (-1,-1,-1) //error
}
    
    
    func getNumDaysInYear(year:Int) -> Int{
        var totalDays = 0
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        
        for month in 1...12{
            dateComponents.month = month
            let date = calendar.dateFromComponents(dateComponents)!
            let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
            totalDays += range.length
        }
        return totalDays
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
    
    func getDayOfWeek(today:String)->Int {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getAlphaValuesForHours(events:[EKEvent]) -> [Double]{
        //var hourValues:[Double] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var hourValues = [Double](count: 24, repeatedValue: 0.1)
        
        for event in events{
            if(!event.allDay){
                
                let startTime = self.getEventStartTimeForUI(event)
                let endTime = self.getEventEndTimeForUI(event)
                
                let startHour:Int = Int(startTime)
                let endHour:Int = Int(ceil(endTime))
                
                //update all the hours
                if startHour <= endHour{
                        var hour = startHour
                        
                        while(hour < endHour ){
                            //if the event is less than one hour
                            if(startHour == endHour){
                                //if the event is 0 in length
                                if(startTime == endTime){
                                    hourValues[hour] += 0.1
                                }else{
                                    hourValues[hour] += Double(endTime) - Double(startTime)
                                }
                            }else if(hour == startHour){
                                if(startTime == Double(startHour)){
                                    hourValues[hour] += 1
                                }else{
                                    hourValues[hour] += (Double(startTime) - Double(startHour))
                                }
                            }else if(hour == endHour - 1){
                                if(endTime == Double(endHour)){
                                    hourValues[hour] += 1
                                }else{
                                    hourValues[hour] += (1 - (Double(endHour) - Double(endTime)))
                                }
                            }else{
                                hourValues[hour] += 1
                            }
                            hour += 1
                        }                    
                }
            }
        }
        return hourValues
    }
    
    
    func getDayString(dayNumber: Int) -> String{
        switch dayNumber{
        case 1:
            return "SUN"
        case 2:
            return "MON"
        case 3:
            return "TUE"
        case 4:
            return "WED"
        case 5:
            return "THU"
        case 6:
            return "FRI"
        case 7:
            return "SAT"
        default:
            return "err"
        }
    }
}