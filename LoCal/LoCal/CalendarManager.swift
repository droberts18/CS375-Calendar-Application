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
    
    var timeString : String = String()
    var date : Int = Int()
    var month : Int = Int()
    var monthString : String = String()
    
    init(){
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            print("Not Determined")
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
            break
            // We need to help them give us permission
            //
            //needPermissionView.fadeIn()
        }
    }
}