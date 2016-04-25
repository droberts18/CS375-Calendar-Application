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
    
    var labelView = UIView()
    var dayLabel = UILabel()
    
    enum SelectionStatus{
        case Normal
        case SelectedItem
        case CurrentlyDisplayedItem
        case Deselected
        case CurrentDay
        case DeselectCurrentDay
        case None
    }
    
    var status = SelectionStatus.None
    
    
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
        
        dayLabel.textColor = whiteColor
        self.setViewStatus(.Normal)
        
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
    
    func setViewStatus(status: SelectionStatus){
        
        let animationTime = 0.05
        
        switch status {
        case .Normal:
            UIView.animateWithDuration(animationTime, animations: {
                self.labelView.layer.borderColor = UIColor.clearColor().CGColor
                self.labelView.layer.borderWidth = 0
                if self.status != SelectionStatus.CurrentDay{
                    self.status = .Normal
                    self.labelView.backgroundColor = self.normalColor
                }
            })
            break
        case .CurrentlyDisplayedItem:
                self.labelView.layer.borderColor = self.blueColor.CGColor
                self.labelView.layer.borderWidth = 2
                if self.status != SelectionStatus.CurrentDay{
                    self.status = .CurrentlyDisplayedItem
                }
            break
        case .CurrentDay:
            UIView.animateWithDuration(animationTime, animations: {
                self.labelView.backgroundColor = self.blueColor
                if self.status != SelectionStatus.CurrentDay{
                    self.status = .CurrentDay
                }
            })
            break
        case .SelectedItem:
                self.labelView.layer.borderColor = self.greenColor.CGColor
                self.labelView.layer.borderWidth = 2
                if self.status != SelectionStatus.CurrentDay{
                    self.status = .SelectedItem
                }
            break
        case .Deselected:
                self.labelView.layer.borderColor = UIColor.clearColor().CGColor
                self.labelView.layer.borderWidth = 0
                if self.status != SelectionStatus.CurrentDay{
                    self.status = .Deselected
                }
            break
        case .DeselectCurrentDay:
            UIView.animateWithDuration(animationTime, animations: {
                self.status = .Normal
                self.labelView.backgroundColor = self.normalColor
            })
        default:
            if self.status != SelectionStatus.CurrentDay{
                self.status = .None
            }
            break
        }
    }
    
    
    
    func getDate()->String{
        return "\(self.month)-\(self.day)-\(self.year)"
    }
}