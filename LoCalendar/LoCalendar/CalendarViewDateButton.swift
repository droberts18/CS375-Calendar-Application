//
//  CalendarViewDateButton.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/14/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

class CalendarViewDateButton: UIButton {
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setButtonDate(date: Int){
        self.setTitle("\(date)", forState: .Normal)
    }
    
    //changes the state of the day
    //0 is normal, 1 is "currently displayed items", 2 is "current day"
    func setViewStatus(status: Int){
        switch status {
        case 0:
            self.backgroundColor = UIColor.blackColor()
            break
        case 1:
            self.backgroundColor = UIColor.grayColor()
            break
        case 2:
            self.backgroundColor = UIColor.redColor()
            break
        default:
            print("Error setting status. Parameter must be 0, 1, or 2")
            print("0 is normal, 1 is \"currently displayed items\", 2 is \"current day\"")
            break
        }
    }
}