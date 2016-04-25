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
        dateContainer.autoMatchDimension(.Width, toDimension: .Width, ofView: container, withMultiplier: 0.33)
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
//        dayName.autoPinEdgeToSuperviewEdge(.Left)
//        dayName.autoPinEdgeToSuperviewEdge(.Top)
//        dayName.autoPinEdgeToSuperviewEdge(.Bottom)
        
        
        
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
        
        // ADDING TAP GESTURE TO BRING UP EVENTS FOR THE DAY
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarScrollCell.seeDayEvents(_:)))
        self.addGestureRecognizer(cellTapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func seeDayEvents(sender: UITapGestureRecognizer? = nil){
        let dayEventsViewController = DayEventsViewController()
        self.window?.rootViewController?.presentViewController(dayEventsViewController, animated: true, completion: nil)
    }
}