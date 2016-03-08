//
//  CalendarDateCell.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/6/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class CalendarDateCell: UITableViewCell {
    let container: UIView = UIView()
    var dayName: UILabel = UILabel()
    var dayDate: UILabel = UILabel()
    
    let dayColor = UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1)
    let dateColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(container)
        container.addSubview(dayName)
        container.addSubview(dayDate)
        
        dayName.textColor = dayColor
        dayDate.textColor = dateColor
        
        dayName.translatesAutoresizingMaskIntoConstraints = false
        dayDate.translatesAutoresizingMaskIntoConstraints = false
        
        dayName.autoPinEdge(.Top, toEdge: .Top, ofView: container)
        dayName.autoPinEdge(.Left, toEdge: .Left, ofView: container)
        dayName.autoPinEdge(.Right, toEdge: .Right, ofView: container)
        dayName.autoPinEdge(.Bottom, toEdge: .Top, ofView: dayDate, withOffset: 5)
        dayName.font = UIFont(name: dayName.font.fontName, size: 15)
        dayName.textAlignment = .Center
        
        dayDate.autoPinEdge(.Left, toEdge: .Left, ofView: container)
        dayDate.autoPinEdge(.Right, toEdge: .Right, ofView: container)
        dayDate.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: container)
        dayDate.font = UIFont(name: dayDate.font.fontName, size: 30)
        dayDate.textAlignment = .Center
        
        container.autoCenterInSuperview()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}