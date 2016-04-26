//
//  CalendarScrollCell.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/15/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

class CalendarScrollCell: UITableViewCell {
    
    let backgColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    var container = UIView(forAutoLayout: ())
    var dateContainer = UIView(forAutoLayout: ())
    var dayName = UILabel(forAutoLayout: ())
    var dayDate = UILabel(forAutoLayout: ())
    var daySummaryContainer = UIView(forAutoLayout: ())

    var day = Int()
    var month = Int()
    var year = Int()
    
    let proportionOfDateContainer:CGFloat = 0.2
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = backgColor
        
        self.contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.autoPinEdgesToSuperviewEdges()
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.redColor().CGColor

        container.addSubview(dateContainer)
        dateContainer.autoPinEdgeToSuperviewEdge(.Left)
        dateContainer.autoPinEdgeToSuperviewEdge(.Top)
        dateContainer.autoPinEdgeToSuperviewEdge(.Bottom)
        dateContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: container, withMultiplier: proportionOfDateContainer)
        dateContainer.layer.borderWidth = 2
        dateContainer.layer.borderColor = UIColor.blueColor().CGColor

        dateContainer.addSubview(dayName)
        dateContainer.addSubview(dayDate)
        dayName.textColor = UIColor.whiteColor()
        dayDate.textColor = UIColor.whiteColor()

        dayName.translatesAutoresizingMaskIntoConstraints = false
        dayDate.translatesAutoresizingMaskIntoConstraints = false
        
        dayName.text = "Hello"
        dayDate.text = "17"
        dayName.autoPinEdge(.Top, toEdge: .Top, ofView: dateContainer)
        dayName.autoPinEdge(.Left, toEdge: .Left, ofView: dateContainer)
        dayName.autoPinEdge(.Right, toEdge: .Right, ofView:dateContainer)
        dayName.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayDate, withOffset: 5)
        dayName.font = UIFont(name: dayName.font.fontName, size: 14)
        dayName.textAlignment = .Left
        
        dayDate.autoPinEdge(.Left, toEdge: .Left, ofView: dateContainer)
        dayDate.autoPinEdge(.Right, toEdge: .Right, ofView: dateContainer)
        dayDate.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: dateContainer)
        dayDate.font = UIFont(name: dayDate.font.fontName, size: 10)
        dayDate.textAlignment = .Left
        
        container.addSubview(daySummaryContainer)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Top)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Bottom)
        daySummaryContainer.autoPinEdgeToSuperviewEdge(.Right)
        daySummaryContainer.autoPinEdge(.Left, toEdge: .Right, ofView: dateContainer)
        daySummaryContainer.layer.borderColor = UIColor.yellowColor().CGColor
        daySummaryContainer.layer.borderWidth = 2
        
        // ADDING TAP GESTURE TO BRING UP EVENTS FOR THE DAY
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarScrollCell.seeDayEvents(_:)))
        self.addGestureRecognizer(cellTapGesture)
        
        self.addEvent(12, endTime: 13.5)
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
    
    func addEvent(startTime:Double,endTime:Double){
        let daySummaryContainerWidth = (1 - proportionOfDateContainer) * self.frame.width
        let dayProportion = daySummaryContainerWidth/24
        var startPositionFraction:CGFloat = 0.0
        var endPositionFraction:CGFloat = 0.0
        var eventWidth:CGFloat = 0
        
        let lengthOfEvent = endTime - startTime
        
        //if the start time is greater than the end time, that means it starts on the previous day
        if(lengthOfEvent > 24){
            
        } else if (endTime < startTime){
            
        } else if(lengthOfEvent >= 0 && lengthOfEvent <= 24){
            //eventWidth = (CGFloat(lengthOfEvent)/dayProportion)*daySummaryContainerWidth
            eventWidth = CGFloat(lengthOfEvent)/24
        } else if (lengthOfEvent == 0){
            eventWidth = 0.05
        }
                
        let newEventView = UIView()
        self.addSubview(newEventView)
        newEventView.autoPinEdgeToSuperviewEdge(.Top)
        newEventView.autoPinEdgeToSuperviewEdge(.Bottom)
        newEventView.autoMatchDimension(.Width, toDimension: .Width, ofView: self.daySummaryContainer,withMultiplier: eventWidth)
        newEventView.autoPinEdge(.Left, toEdge: .Left, ofView: self.daySummaryContainer, withOffset: CGFloat(startTime)*dayProportion)
//        newEventView.autoPinEdge(.Right, toEdge: .Right, ofView: self.daySummaryContainer, withOffset: 0)
        
        newEventView.backgroundColor = UIColor.redColor()
        
        
        
    }
    
    func seeDayEvents(sender: UITapGestureRecognizer? = nil){
        let dayEventsViewController = DayEventsViewController()
        self.window?.rootViewController?.presentViewController(dayEventsViewController, animated: true, completion: nil)
    }
}