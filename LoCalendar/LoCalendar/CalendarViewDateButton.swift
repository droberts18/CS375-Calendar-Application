//
//  CalendarViewDateButton.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/14/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

class CalendarViewDateButton: UIButton {
    
    let normalColor = UIColor(red: 58/255, green: 61/255, blue: 76/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    var day = Int()
    var month = Int()
    var year = Int()
    
//    var container = UIView()
//    var dateLabel = UILabel()
    //var button = UIButton()
    var labelView = UIView()
    var dayLabel = UILabel()
    
    
    convenience init (month:Int, day: Int, year:Int) {
        self.init(frame:CGRect.zero)
        

        self.addSubview(labelView)
        self.labelView.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 0.85)
        self.labelView.autoMatchDimension(.Width, toDimension: .Width, ofView: self, withMultiplier: 0.85)
        self.labelView.autoCenterInSuperview()
        self.labelView.layer.cornerRadius = 10
        
        self.labelView.addSubview(dayLabel)
        dayLabel.text = "\(day)"
        dayLabel.textAlignment = .Center
        dayLabel.autoCenterInSuperview()
        
        self.userInteractionEnabled = true
        self.labelView.userInteractionEnabled = false
        
//        self.label.setTitle("\(day)", forState: .Normal)
//        self.label.titleLabel?.textAlignment = .Center
        
        
        
//        self.container.addSubview(dateLabel)
//        dateLabel.textAlignment = .Center
//        dateLabel.autoCenterInSuperview()
        dayLabel.textColor = whiteColor
        self.setViewStatus(0)
        
        //self.dateLabel.text = "\(day)"
        self.day = day
        self.month = month
        self.year = year
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    //changes the state of the day
    //0 is normal, 1 is "currently displayed items", 2 is "current day"
    func setViewStatus(status: Int){
        switch status {
        case 0:
            self.labelView.backgroundColor = normalColor
            break
        case 1:
            self.labelView.backgroundColor = lightDarkColor
            break
        case 2:
            self.labelView.backgroundColor = greenColor
            break
        default:
            print("Error setting status. Parameter must be 0, 1, or 2")
            print("0 is normal, 1 is \"currently displayed items\", 2 is \"current day\"")
            break
        }
    }
    
    func getDate()->String{
        return "\(self.month)-\(self.day)-\(self.year)"
    }
}