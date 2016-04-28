//
//  CalendarScrollCell.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/15/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

class CalendarScrollCell: UITableViewCell {
    
    let normalColor = UIColor(red: 58/255, green: 61/255, blue: 76/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    let backgColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    
    
    var container = UIView(forAutoLayout: ())
    var dateContainer = UIView(forAutoLayout: ())
    var dayName = UILabel(forAutoLayout: ())
    var dayDate = UILabel(forAutoLayout: ())
    var daySummaryContainer = UIView(forAutoLayout: ())
    
    //    var eventSummaryViews = [UIView]()
    //    var addedViews = false
    
    var hourHeatMapViews = [UIView]()
    
    var day = Int()
    var month = Int()
    var year = Int()
    
    let proportionOfDateContainer:CGFloat = 0.13
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = backgColor
        self.layer.borderWidth = 0
        
        self.contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.autoPinEdgesToSuperviewEdges()
        
        container.addSubview(dateContainer)
        dateContainer.autoPinEdgeToSuperviewEdge(.Left)
        dateContainer.autoPinEdgeToSuperviewEdge(.Top)
        dateContainer.autoPinEdgeToSuperviewEdge(.Bottom)
        dateContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: container, withMultiplier: proportionOfDateContainer)
        
        dateContainer.addSubview(dayName)
        dateContainer.addSubview(dayDate)
        dayName.textColor = UIColor.whiteColor()
        dayDate.textColor = UIColor.whiteColor()
        
        dayName.translatesAutoresizingMaskIntoConstraints = false
        dayDate.translatesAutoresizingMaskIntoConstraints = false
        
        dayName.autoPinEdge(.Top, toEdge: .Top, ofView: dateContainer)
        dayName.autoPinEdge(.Left, toEdge: .Left, ofView: dateContainer)
        dayName.autoPinEdge(.Right, toEdge: .Right, ofView:dateContainer)
        dayName.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayDate)
        dayName.font = UIFont(name: dayName.font.fontName, size: 17)
        dayName.textAlignment = .Center
        
        dayDate.autoPinEdge(.Left, toEdge: .Left, ofView: dateContainer)
        dayDate.autoPinEdge(.Right, toEdge: .Right, ofView: dateContainer)
        dayDate.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: dateContainer)
        dayDate.font = UIFont(name: dayDate.font.fontName, size: 15)
        dayDate.textAlignment = .Center
        
        container.addSubview(daySummaryContainer)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Top)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Bottom)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Right)
        daySummaryContainer.autoPinEdge(.Left, toEdge: .Right, ofView: dateContainer)
        
        // ADDING TAP GESTURE TO BRING UP EVENTS FOR THE DAY
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarScrollCell.seeDayEvents(_:)))
        self.addGestureRecognizer(cellTapGesture)
        
        var previousHour = UIView()
        var first = true
        
        //add views for heat map
        for index in 0...23{
            var hourCell = UIView()
            self.daySummaryContainer.addSubview(hourCell)
            hourCell.autoMatchDimension(.Width, toDimension: .Width, ofView: daySummaryContainer, withMultiplier: 1/24)
            hourCell.autoPinEdgeToSuperviewEdge(.Top)
            hourCell.autoPinEdgeToSuperviewEdge(.Bottom)
            
            let hourLabel = UILabel()
            hourCell.addSubview(hourLabel)
            hourLabel.autoCenterInSuperview()
            hourLabel.textAlignment = .Center
            hourLabel.autoPinEdgesToSuperviewEdges()
            hourLabel.textColor = UIColor.whiteColor()
            hourLabel.font = hourLabel.font.fontWithSize(10)
            
            if first{
                hourLabel.text = "12"
            }else if(index < 13){
                hourLabel.text = "\(index)"
            }else{
                hourLabel.text = "\(index - 12)"
            }
            
            if first{
                hourCell.autoPinEdge(.Left, toEdge: .Left, ofView: self.daySummaryContainer)
                first = false
            }else{
                hourCell.autoPinEdge(.Left, toEdge: .Right, ofView: previousHour)
            }
            previousHour = hourCell
            hourCell.backgroundColor = blueColor
            hourCell.alpha = 0.1
            hourCell.layer.borderWidth = 0.5
            hourCell.layer.borderColor = darkColor.CGColor
            self.hourHeatMapViews.append(hourCell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getDate() -> String{
        return "\(self.month)-\(self.day)-\(self.year)"
    }
    
    func resetHeatMap(){
        //reset all the alpha values
        for hour in self.hourHeatMapViews{
            hour.alpha = 0.1
        }
    }
    
    
    //    func updateHeatMapWithHours(startTime:Double,endTime:Double){
    //        let startHour:Int = Int(startTime)
    //        let endHour:Int = Int(ceil(endTime))
    //
    //        //update all the hours
    //        if startHour <= endHour{
    //            UIView.animateWithDuration(0.5, animations: {
    //                var hour = startHour
    //
    //                while(hour < endHour ){
    //                    //if the event is less than one hour
    //                    if(startHour == endHour){
    //                        //if the event is 0 in length
    //                        if(startTime == endTime){
    //                            self.hourHeatMapViews[hour].alpha += 0.1
    //                        }else{
    //                            self.hourHeatMapViews[hour].alpha += CGFloat(endTime) - CGFloat(startTime)
    //                        }
    //                        return
    //                    }else if(hour == startHour){
    //                        if(startTime == Double(startHour)){
    //                            self.hourHeatMapViews[hour].alpha += 1
    //                        }else{
    //                            self.hourHeatMapViews[hour].alpha += (CGFloat(startTime) - CGFloat(startHour))
    //                        }
    //                    }else if(hour == endHour - 1){
    //                        if(endTime == Double(endHour)){
    //                            self.hourHeatMapViews[hour].alpha += 1
    //                        }else{
    //                            self.hourHeatMapViews[hour].alpha += (1 - (CGFloat(endHour) - CGFloat(endTime)))
    //                        }
    //                        return
    //                    }else{
    //                        self.hourHeatMapViews[hour].alpha += 1
    //                    }
    //                    hour += 1
    //                }
    //            })
    //
    //        }
    //    }
    
    //    func clearEventViews(){
    //        for event in eventSummaryViews{
    //            event.removeFromSuperview()
    //        }
    //        eventSummaryViews.removeAll()
    //    }
    //
    //    func addEvent(startTime:Double,endTime:Double){
    //        let daySummaryContainerWidth = (1 - proportionOfDateContainer) * self.frame.width
    //        let dayProportion = daySummaryContainerWidth/24
    ////        var startPositionFraction:CGFloat = 0.0
    ////        var endPositionFraction:CGFloat = 0.0
    //        var eventWidth:CGFloat = 0
    //
    //        let lengthOfEvent = endTime - startTime
    //
    //        //if the start time is greater than the end time, that means it starts on the previous day
    //        if(lengthOfEvent > 24){
    //
    //        } else if (endTime < startTime){
    //
    //        } else if(lengthOfEvent >= 0 && lengthOfEvent <= 24){
    //            //eventWidth = (CGFloat(lengthOfEvent)/dayProportion)*daySummaryContainerWidth
    //            eventWidth = CGFloat(lengthOfEvent)/24
    //        } else if (lengthOfEvent == 0){
    //            eventWidth = 0.05
    //        }
    //
    //        let newEventView = UIView()
    //        self.addSubview(newEventView)
    //        newEventView.alpha = 0.7
    //        newEventView.layer.cornerRadius = 5
    //        newEventView.backgroundColor = blueColor
    //
    //        newEventView.autoMatchDimension(.Height, toDimension: .Height, ofView: self.daySummaryContainer, withMultiplier: 0.5)
    //        newEventView.autoAlignAxis(.Horizontal, toSameAxisOfView: self.daySummaryContainer)
    ////        newEventView.autoPinEdgeToSuperviewEdge(.Top)
    ////        newEventView.autoPinEdgeToSuperviewEdge(.Bottom)
    //        newEventView.autoMatchDimension(.Width, toDimension: .Width, ofView: self.daySummaryContainer,withMultiplier: eventWidth)
    //        newEventView.autoPinEdge(.Left, toEdge: .Left, ofView: self.daySummaryContainer, withOffset: CGFloat(startTime)*dayProportion)
    //        
    //        self.addedViews = true
    //        self.eventSummaryViews.append(newEventView)
    //    }
    
    func seeDayEvents(sender: UITapGestureRecognizer? = nil){
        let dayEventsViewController = DayEventsViewController()
        self.window?.rootViewController?.presentViewController(dayEventsViewController, animated: true, completion: nil)
    }
}