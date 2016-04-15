//
//  CalendarView.swift
//  
//
//  Created by Tyler Reardon on 4/14/16.
//
//

import Foundation

class CalendarView: UIView{
    
    var monthName = String()
    var dayNames:[String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var daysInMonth = Int()
    let dayHeight:CGFloat = 30.0
    
    var monthLabel = UILabel()
    var dayLabels:[UILabel] = []
    var dateLabels:[UILabel] = []
    
    convenience init(){
        self.init(frame: CGRect.zero)
        
        
        //set month day label
        self.addSubview(monthLabel)
        monthLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        monthLabel.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        monthLabel.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        monthLabel.autoSetDimension(.Height, toSize: dayHeight)
        monthLabel.layer.borderColor = UIColor.whiteColor().CGColor
        monthLabel.layer.borderWidth = 2
        monthLabel.textColor = UIColor.whiteColor()
        monthLabel.textAlignment = .Center
        
        
        //set days of the week
        for day in dayNames{
            let dayName = UILabel()
            dayName.text = day
            dayLabels.append(dayName)
        }
        
        var prevDay = UIView()
        var first = true
        for day in dayLabels{
            
            day.textAlignment = .Center
            day.textColor = UIColor.whiteColor()
            day.layer.borderWidth = 1
            day.layer.borderColor = UIColor.redColor().CGColor
            
            self.addSubview(day)
            day.autoPinEdge(.Top, toEdge: .Bottom, ofView: monthLabel)
            day.autoMatchDimension(.Width, toDimension: .Width, ofView: self, withMultiplier: 1/7)
            day.autoSetDimension(.Height, toSize: dayHeight)
            if first{
                day.autoPinEdge(.Left, toEdge: .Left, ofView: self)
                first = false
            }else{
                day.autoPinEdge(.Left, toEdge: .Right, ofView: prevDay)
            }
            prevDay = day
        }
        
        self.setMonth(1)
        self.setDaysInMonth(31, startDay: 6)
        
    }
    
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
    
    //takes the number of days in a month and what day of the week sunday through saturday (0-6)
    func setDaysInMonth(numDaysInMonth:Int, startDay:Int){
        
        if(startDay >= dayLabels.count || startDay < 0){
            print("Invalid starting day number")
            return
        }else if(numDaysInMonth > 31 || numDaysInMonth < 1){
            print("Invalid number of days in month")
            return
        }
        
        var currentDayOfWeek = startDay
        var prevDate = UIButton()
        var first = true
        var i = 0
        while i < numDaysInMonth{
            let dateContainer = CalendarViewDateButton()
            self.addSubview(dateContainer)
            dateContainer.autoSetDimension(.Height, toSize: dayHeight)
            dateContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: self, withMultiplier: 1/7)
            dateContainer.setButtonDate(i+1)
            
            dateContainer.setViewStatus(1)
            
            
            dateContainer.layer.cornerRadius = 10
            dateContainer.layer.borderColor = UIColor.greenColor().CGColor
            dateContainer.layer.borderWidth = 1
            
            if first{
                dateContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: dayLabels[startDay])
                dateContainer.autoPinEdge(.Left, toEdge: .Left, ofView: dayLabels[startDay])
                first = false
            }else if currentDayOfWeek > 0{
                dateContainer.autoPinEdge(.Top, toEdge: .Top, ofView: prevDate)
                dateContainer.autoPinEdge(.Left, toEdge: .Right, ofView: prevDate)
            }else if currentDayOfWeek == 0{
                dateContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: prevDate)
                dateContainer.autoPinEdge(.Left, toEdge: .Left, ofView: dayLabels[0])
            }
            
            
            if currentDayOfWeek == 6{
                currentDayOfWeek = 0
            }else{
                currentDayOfWeek += 1
            }
            
            prevDate = dateContainer
            i+=1
        }
    }
}