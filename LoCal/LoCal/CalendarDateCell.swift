//
//  CalendarDateCell.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/6/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class CalendarDateCell: UITableViewCell {
    var dayName: UILabel = UILabel()
    var dayDate: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(dayName)
        self.contentView.addSubview(dayDate)
        
        dayName.textColor = UIColor.whiteColor()
        dayDate.textColor = UIColor.whiteColor()
        
        dayName.translatesAutoresizingMaskIntoConstraints = false
        dayDate.translatesAutoresizingMaskIntoConstraints = false
        
        dayName.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        dayName.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        dayName.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        dayName.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayDate)
        
        dayDate.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        dayDate.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        dayDate.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}