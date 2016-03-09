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

    
    init(){
        checkCalendarAuthorizationStatus()
        getNumDaysInMonth(6, year: 2016)
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
        
        print("\(month),\(day),\(year)")
            
            let store = EKEventStore()
            
            let fetchEvents = { () -> Void in
                
                let predicate = store.predicateForEventsWithStartDate(oneYearAgo, endDate:oneYearFromNow, calendars: nil)
                
                // if can return nil for no events between these dates
                let events = store.eventsMatchingPredicate(predicate)
                for event in events{
                    print(event)
                }
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}