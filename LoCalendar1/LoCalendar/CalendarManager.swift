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

        //self.getDateFromCurrentDateWithOffset(40)
        
        fillDateMap()
        print("finished")
    }
    
    func fillDateMap() -> [String:Int]{
        var dateMap = [String:Int]()
        var rowIndex = 0
        
        for myYear in self.currentYear-50...self.currentYear+50{
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
    
    func getEventsForDate(date: NSDate){
        
        let beginningOfDay = calendar.startOfDayForDate(date)
        
        var endOfDay: NSDate? {
            let components = NSDateComponents()
            components.day = 1
            components.second = -1
            return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: beginningOfDay, options: NSCalendarOptions())
        }
        
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendarsForEntityType(.Event)
        
        for calendar in calendars {
            //if calendar.title == "Work" {
            
            let myPredicate = eventStore.predicateForEventsWithStartDate(beginningOfDay, endDate: endOfDay!, calendars: [calendar])
            
            
                //var events = eventStore.eventsMatchingPredicate(predicate)
            var events = eventStore.eventsMatchingPredicate(myPredicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate)
                    endDates.append(event.endDate)
                }
            //}
        }
    }
    
    func getEventStartTime(event: EKEvent) -> String{
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
    
    func getEventEndTime(event: EKEvent) -> String{
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
    
    func getDayString(dayNumber: Int) -> String{
        switch dayNumber{
        case 0:
            return "SUN"
        case 1:
            return "MON"
        case 2:
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            return "err"
        }
    }
}