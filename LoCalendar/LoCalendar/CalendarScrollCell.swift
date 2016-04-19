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
        //self.contentView.userInteractionEnabled = true
        
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
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
        dayName.autoPinEdgeToSuperviewEdge(.Left)
        dayName.autoPinEdgeToSuperviewEdge(.Top)
        dayName.autoPinEdgeToSuperviewEdge(.Bottom)
        
        
//        
//        dayName.autoPinEdge(.Top, toEdge: .Top, ofView: container)
//        dayName.autoPinEdge(.Left, toEdge: .Left, ofView: container)
//        dayName.autoPinEdge(.Right, toEdge: .Right, ofView: container)
//        dayName.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayDate, withOffset: 5)
//        dayName.font = UIFont(name: dayName.font.fontName, size: 14)
//        dayName.textAlignment = .Center
//        
//        dayDate.autoPinEdge(.Left, toEdge: .Left, ofView: container)
//        dayDate.autoPinEdge(.Right, toEdge: .Right, ofView: container)
//        dayDate.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: container)
//        dayDate.font = UIFont(name: dayDate.font.fontName, size: 27)
//        dayDate.textAlignment = .Center
//        
//        container.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}