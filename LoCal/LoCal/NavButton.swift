//
//  NavButton.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/2/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class NavButton: UIButton {
    
    let eventView = UIView()
    let addEventButton = UIButton()
    var imageFileName = String()
    
    var buttonColor = UIColor.whiteColor()
    var navButtonSize : CGFloat = 50
    var navButtonImageSize : CGFloat = 25
    var navButtonBorderWidth : CGFloat = 2
    var navButtonBorderColor = UIColor.whiteColor()
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init (buttonColor: UIColor, imageFileName: String) {
        self.init(frame:CGRect.zero)
        self.buttonColor = buttonColor
        self.imageFileName = imageFileName
        customInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func customInitialization(){
//        self.addSubview(eventView)
//        eventView.userInteractionEnabled = true
//        addEventButton.userInteractionEnabled = true
//
//        eventView.translatesAutoresizingMaskIntoConstraints = false
//        addEventButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        eventView.backgroundColor = UIColor.whiteColor()
//        eventView.autoSetDimension(.Width, toSize: navButtonSize)
//        eventView.autoMatchDimension(.Height, toDimension: .Width, ofView: eventView, withMultiplier: 1)
//        eventView.layer.cornerRadius = navButtonSize/2
//        eventView.backgroundColor = buttonColor
//        eventView.autoCenterInSuperview()
//        
//        eventView.addSubview(addEventButton)
//        addEventButton.autoCenterInSuperview()
//        addEventButton.autoMatchDimension(.Width, toDimension: .Width, ofView: eventView)
//        addEventButton.autoMatchDimension(.Height, toDimension: .Height, ofView: eventView)
//        addEventButton.backgroundColor = buttonColor
//        addEventButton.layer.cornerRadius = navButtonSize/2
//        addEventButton.layer.borderWidth = navButtonBorderWidth
//        addEventButton.layer.borderColor = navButtonBorderColor.CGColor
//        
//        let addEventImage = UIImage(named: imageFileName)
//        let addEventImageView = UIImageView(image: addEventImage)
//        eventView.addSubview(addEventImageView)
//        addEventImageView.autoCenterInSuperview()
//        addEventImageView.autoSetDimension(.Height, toSize: navButtonImageSize)
//        addEventImageView.autoSetDimension(.Width, toSize: navButtonImageSize)
        
        //addEventButton.addTarget(self, action: "onButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.autoSetDimension(.Width, toSize: navButtonSize)
        self.autoSetDimension(.Height, toSize: navButtonSize)
        self.backgroundColor = buttonColor
        self.layer.cornerRadius = navButtonSize/2
        self.layer.borderWidth = 2
        self.layer.borderColor = navButtonBorderColor.CGColor
        self.userInteractionEnabled = true
        let buttonImage = UIImage(named: imageFileName)
        let buttonImageView = UIImageView(image: buttonImage)
        self.addSubview(buttonImageView)
        buttonImageView.autoSetDimension(.Height, toSize: navButtonImageSize)
        buttonImageView.autoSetDimension(.Width, toSize: navButtonImageSize)
        buttonImageView.autoCenterInSuperview()
    }
    
//    func onButtonTap(sender:UIButton!){
//        print("This worked!!")
//        //self.presentViewController(AddEventViewController(), animated : true, completion : nil)
//    }
}