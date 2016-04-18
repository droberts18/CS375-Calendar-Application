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
    var eventDictionary = [String:[EKEvent]]()
    var authorized = false
    
    init(){
        checkStatus()
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