//
//  CalendarManager.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/8/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    
    let eventStore = EKEventStore()
    let calendar = NSCalendar.currentCalendar()
    var eventDictionary = [String:[EKEvent]]()
    var eventsLoaded : Bool = false
    
    init(){
        checkCalendarAuthorizationStatus()
        //getNumDaysInMonth(6, year: 2016)
        loadEventsInCalendar()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: {_,_ in print("")})
            break
            // This happens on first-run
            //requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            print("Authorized")
            break
            // Things are in line with being able to show the calendars in the table view
            //loadCalendars()
            //refreshTableView()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            print("Denied")
            eventStore.requestAccessToEntityType(.Event, completion: {_,_ in print("")})
            break
            // We need to help them give us permission
            //
            //needPermissionView.fadeIn()
        }
    }
    
    func getNumDaysInMonth(month: Int, year: Int) -> Int{
        
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let date = calendar.dateFromComponents(dateComponents)!
        
        let numberOfDaysInMonth = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
        
        return numberOfDaysInMonth
    }
    
    func loadEventsInCalendar() {
        
        let currentDate = NSDate()
        let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        var oneYearAgo = NSDate()
        let oneYearAgoComponents = NSDateComponents()
        oneYearAgoComponents.year = year - 1
        oneYearAgoComponents.month = month
        oneYearAgoComponents.day = day
        oneYearAgo = self.calendar.dateFromComponents(oneYearAgoComponents)!
        
        var oneYearFromNow = NSDate()
        let oneYearFromNowComponents = NSDateComponents()
        oneYearFromNowComponents.year = year + 1
        oneYearFromNowComponents.month = month
        oneYearFromNowComponents.day = day
        oneYearFromNow = self.calendar.dateFromComponents(oneYearFromNowComponents)!
        
            let store = EKEventStore()
            
            let fetchEvents = { () -> Void in
                
                let predicate = store.predicateForEventsWithStartDate(oneYearAgo, endDate:oneYearFromNow, calendars: nil)
                
                // if can return nil for no events between these dates
                let events = store.eventsMatchingPredicate(predicate)
                for event in events{
                    let dateComponents = self.calendar.components([.Day , .Month , .Year], fromDate: event.startDate)
                    let eventYear =  dateComponents.year
                    let eventMonth = dateComponents.month
                    let eventDay = dateComponents.day
                    let dateString = "\(eventMonth)-\(eventDay)-\(eventYear)"
                    
                    if self.eventDictionary[dateString] == nil {
                        self.eventDictionary[dateString] = [EKEvent]()
                    }
                    self.eventDictionary[dateString]!.append(event)
                    
                }
                self.eventsLoaded = true
            }
            
            if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) != EKAuthorizationStatus.Authorized {
                
                store.requestAccessToEntityType(EKEntityType.Event, completion: {(granted : Bool, error : NSError?) -> Void in
                    if granted {
                        fetchEvents()
                    }
                })
                
            } else {
                fetchEvents()
            }
    }
    
    func getDateString(date: NSDate) -> String{
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return "\(month)-\(day)-\(year)"
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
    
    func getMonthString(monthNumber: Int) -> String{
        switch monthNumber{
        case 1:
            return "JANUARY"
        case 2:
            return "FEBRUARY"
        case 3:
            return "MARCH"
        case 4:
            return "APRIL"
        case 5:
            return "MAY"
        case 6:
            return "JUNE"
        case 7:
            return "JULY"
        case 8:
            return "AUGUST"
        case 9:
            return "SEPTEMBER"
        case 10:
            return "OCTOBER"
        case 11:
            return "NOVEMBER"
        case 12:
            return "DECEMBER"
        default:
            return "err"
        }
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