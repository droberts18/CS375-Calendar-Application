//
//  AddEventViewController.swift
//  LoCalendar
//
//  Created by Drew Roberts on 5/6/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation
import UIKit

class AddEventViewController: UIViewController {
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let exitButtonIMG = UIImage(named: "AddEventButtonPlus.png")
    let eventName = UITextField()
    let changeStartDateButton = UIButton()
    let changeEndDateButton = UIButton()
    
    override func viewDidLoad() {
        self.view.backgroundColor = darkColor
        let font = UIFont.systemFontOfSize(40)
        let font2 = UIFont.systemFontOfSize(20)
        
        let exitButton = UIImageView(image: exitButtonIMG)
        self.view.addSubview(exitButton)
        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 5)
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 5)
        exitButton.transform = CGAffineTransformMakeRotation((CGFloat(M_PI)/180)*45)
        exitButton.userInteractionEnabled = true
        let exitTap = UITapGestureRecognizer(target: self, action: #selector(AddEventViewController.exit(_:)))
        exitButton.addGestureRecognizer(exitTap)
        
        self.view.addSubview(eventName)
        eventName.text = "Event Name"
        eventName.font = font
        eventName.autoSetDimension(.Height, toSize: 50)
        eventName.borderStyle = UITextBorderStyle.RoundedRect
        eventName.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 20)
        eventName.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -20)
        eventName.autoPinEdge(.Top, toEdge: .Bottom, ofView: exitButton, withOffset: 50)
        eventName.backgroundColor = lightDarkColor
        eventName.textColor = whiteColor

        self.view.addSubview(changeStartDateButton)
        changeStartDateButton.autoPinEdge(.Right, toEdge: .Right, ofView: eventName)
        changeStartDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: eventName)
        changeStartDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: eventName, withOffset: 20)
        changeStartDateButton.backgroundColor = lightDarkColor
        changeStartDateButton.setTitle("TAP TO SET START DATE", forState: UIControlState.Normal)
        changeStartDateButton.setTitleColor(greenColor, forState: UIControlState.Normal)
        changeStartDateButton.addTarget(self, action: "openCalendar:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(changeEndDateButton)
        changeEndDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: eventName)
        changeEndDateButton.autoPinEdge(.Right, toEdge: .Right, ofView: eventName)
        changeEndDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: changeStartDateButton, withOffset: 20)
        changeEndDateButton.backgroundColor = lightDarkColor
        changeEndDateButton.setTitle("TAP TO SET END DATE", forState: UIControlState.Normal)
        changeEndDateButton.setTitleColor(greenColor, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func exit(e: UITapGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func openCalendar(sender: UIButton!){
        //need animation
    }
}


