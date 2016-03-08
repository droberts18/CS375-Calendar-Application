//
//  EventView.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/7/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class EventView: UIView {
    var timeLabel : UILabel = UILabel()
    var titleLabel : UILabel = UILabel()
    var locationLabel : UILabel = UILabel()
    var locationSymbol : UIImageView = UIImageView()
    
    var pastEvent : Bool = false
    var currentEvent : Bool = false
    
    convenience init(time: String, title: String, location: String){
        self.init(frame:CGRect.zero)
        self.autoSetDimension(.Height, toSize: 40)
        
        
        self.addSubview(timeLabel)
        timeLabel.text = time
        
        self.addSubview(titleLabel)
        titleLabel.text = title
        
        self.addSubview(locationLabel)
        locationLabel.text = location
        
        let locationImage = UIImage(named: "locationPin.png")
        locationSymbol = UIImageView(image: locationImage)
    }
    
}