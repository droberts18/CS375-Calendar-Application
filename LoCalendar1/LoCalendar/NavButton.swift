//
//  NavButton.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 5/1/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

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
    var buttonWidth = NSLayoutConstraint()
    var buttonHeight = NSLayoutConstraint()
    var sizeRatio : CGFloat = CGFloat()
    var buttonTapped = false
    
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
        buttonHeight = self.autoSetDimension(.Height, toSize: navButtonSize)
        buttonWidth = self.autoSetDimension(.Width, toSize: navButtonSize)
        
        self.backgroundColor = buttonColor
        self.layer.cornerRadius = navButtonSize/2
        self.layer.borderWidth = 2
        self.layer.borderColor = navButtonBorderColor.CGColor
        self.userInteractionEnabled = true
        
        let buttonImage = UIImage(named: imageFileName)
        let buttonImageView = UIImageView(image: buttonImage)
        self.sizeRatio = (buttonImage?.size.width)!/(buttonImage?.size.height)!
        
        self.addSubview(buttonImageView)
        buttonImageView.autoSetDimension(.Height, toSize: navButtonImageSize)
        buttonImageView.autoMatchDimension(.Width, toDimension: .Height, ofView: buttonImageView, withMultiplier: self.sizeRatio)
        buttonImageView.autoCenterInSuperview()
        
        self.addTarget(self, action: #selector(NavButton.onSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onSelect(sender: UIButton!){
        let degrees:CGFloat = 45; //the value in degrees
        
        if(!self.buttonTapped){
            UIView.animateWithDuration(0.33, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformMakeRotation(degrees * CGFloat(M_PI)/180) //rotate the view by n degrees
                }, completion: { (value: Bool) in
            })
            self.buttonTapped = true
        }else{
            UIView.animateWithDuration(0.33, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformIdentity //set back to original position
                }, completion: { (value: Bool) in
            })
            self.buttonTapped = false
        }
        
    }
}