//
//  EventView.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/7/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class EventView: UIView {
    let timeContainer = UIView(forAutoLayout: ())
    var timeLabel : UILabel = UILabel(forAutoLayout: ())
    
    let infoContainer = UIView(forAutoLayout: ())
    var titleLabel : UILabel = UILabel(forAutoLayout: ())
    var locationLabel : UILabel = UILabel(forAutoLayout: ())
    var locationSymbol : UIImageView = UIImageView(forAutoLayout: ())
    
    let statusContainer = UIView(forAutoLayout: ())
    var statusIndicator : UIImageView = UIImageView(forAutoLayout: ())
    
    var pastEvent : Bool = false
    var currentEvent : Bool = false
    
    var topSpace : CGFloat = 5
    let eventHeight : CGFloat = 35
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let timeColor = UIColor(red: 215/255, green: 131/255, blue: 25/255, alpha: 1)

    
    convenience init(time: String, title: String, location: String){
        self.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.text = time
        titleLabel.text = title
        locationLabel.text = location
        
        self.titleLabel.textColor = whiteColor
        self.locationLabel.textColor = whiteColor
        self.timeLabel.textColor = whiteColor
        self.autoSetDimension(.Height, toSize: self.eventHeight)
        
        //TIME CONTAINER
        self.addSubview(timeContainer)
        self.timeContainer.translatesAutoresizingMaskIntoConstraints = false
        self.timeContainer.addSubview(self.timeLabel)
        self.timeContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        self.timeContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        self.timeContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        self.timeContainer.autoSetDimension(.Width, toSize: 60)
        self.timeLabel.autoPinEdge(.Left, toEdge: .Left, ofView: timeContainer, withOffset: 5)
        self.timeLabel.autoPinEdge(.Right, toEdge: .Right, ofView: timeContainer)
        //self.timeLabel.autoPinEdge(.Top, toEdge: .Top, ofView: timeContainer, withOffset: self.topSpace)
        self.timeLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: timeContainer)
        self.timeLabel.font = self.timeLabel.font.fontWithSize(13)
        self.timeLabel.textColor = self.timeColor
        //self.timeContainer.backgroundColor = UIColor.blueColor() //DEBUGGING
        //END TIME CONTAINER
        
        //INFO CONTAINER
//        
//        let locationImage = UIImage(named: "locationPin.png")
//        self.locationSymbol = UIImageView(image: locationImage)
//        self.infoContainer.addSubview(locationSymbol)
//        self.locationSymbol.translatesAutoresizingMaskIntoConstraints = false
//        let imageRatio = (locationImage?.size.width)!/(locationImage?.size.height)!
//        self.locationSymbol.autoSetDimension(.Height, toSize: 12)
//        self.locationSymbol.autoMatchDimension(.Width, toDimension: .Height, ofView: self.locationSymbol, withMultiplier: imageRatio)
//        self.locationSymbol.autoPinEdge(.Left, toEdge: .Left, ofView: infoContainer, withOffset: 10)
//        //self.locationSymbol.autoPinEdge(.Top, toEdge: .Top, ofView: infoContainer, withOffset: self.topSpace + 3)
//        self.locationSymbol.autoAlignAxis(.Horizontal, toSameAxisOfView: infoContainer)
//        
//        self.addSubview(infoContainer)
//        self.infoContainer.translatesAutoresizingMaskIntoConstraints = false
//        self.infoContainer.autoPinEdge(.Left, toEdge: .Right, ofView: timeContainer)
//        self.infoContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self)
//        self.infoContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self)
//        self.infoContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
//        self.infoContainer.addSubview(titleLabel)
//        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: locationSymbol, withOffset: 5)
//        //self.titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: infoContainer, withOffset: self.topSpace)
//        self.titleLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: infoContainer)
//        self.titleLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoContainer)
//        self.titleLabel.font = self.titleLabel.font.fontWithSize(14)

        
//        self.infoContainer.backgroundColor = UIColor.greenColor() //DEBUGGING
//        self.infoContainer.backgroundColor = UIColor.greenColor() //DEBUGGING

        
        
        
        
        self.addSubview(infoContainer)
        self.infoContainer.translatesAutoresizingMaskIntoConstraints = false
        self.infoContainer.autoPinEdge(.Left, toEdge: .Right, ofView: timeContainer)
        self.infoContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        self.infoContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        self.infoContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        self.infoContainer.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: infoContainer, withOffset: 20)
        self.titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: infoContainer, withOffset: self.topSpace)
        self.titleLabel.autoPinEdge(.Right, toEdge: .Right, ofView: infoContainer)
        self.titleLabel.font = self.titleLabel.font.fontWithSize(14)
        //self.infoContainer.backgroundColor = UIColor.greenColor() //DEBUGGING
        
        let locationImage = UIImage(named: "locationPin.png")
        self.locationSymbol = UIImageView(image: locationImage)
        self.infoContainer.addSubview(locationSymbol)
        self.locationSymbol.translatesAutoresizingMaskIntoConstraints = false
        let imageRatio = (locationImage?.size.width)!/(locationImage?.size.height)!
        self.locationSymbol.autoSetDimension(.Height, toSize: 12)
        self.locationSymbol.autoMatchDimension(.Width, toDimension: .Height, ofView: self.locationSymbol, withMultiplier: imageRatio)
        self.locationSymbol.autoPinEdge(.Left, toEdge: .Left, ofView: self.titleLabel)
        self.locationSymbol.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel)
        
        self.infoContainer.addSubview(locationLabel)
        self.locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel)
        self.locationLabel.autoPinEdge(.Left, toEdge: .Right, ofView: self.locationSymbol, withOffset: 5)
        self.locationLabel.font = self.locationLabel.font.fontWithSize(12)
        //END INFO CONTAINER
        
        
        
        
        
    }
    
}