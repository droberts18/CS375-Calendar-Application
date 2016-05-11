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
    let startDateCalendarContainer = UIView()
    let endDateCalendarContainer = UIView()
    let startDateCalendar = CalendarView()
    let endDateCalendar = CalendarView()
    
    var startDateCalendarIsOpen = false
    var endDateCalendarIsOpen = false
    var bottomOfStartDateCalendarView = NSLayoutConstraint()
    var bottomOfEndDateCalendarView = NSLayoutConstraint()
    
    // need to change shade of green
    let searchMapButton = NavButton(buttonColor: UIColor.greenColor(), imageFileName: "SearchMapButton.png")
    
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
        changeStartDateButton.addTarget(self, action: #selector(AddEventViewController.openStartDateCalendar(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startDateCalendarContainer)
        startDateCalendarContainer.backgroundColor = greenColor
        startDateCalendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        startDateCalendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        startDateCalendarContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: changeStartDateButton)
        startDateCalendarContainer.autoSetDimension(.Height, toSize: 300)
        self.bottomOfStartDateCalendarView = startDateCalendarContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: changeStartDateButton)
        
        startDateCalendarContainer.addSubview(startDateCalendar)
        startDateCalendar.autoPinEdge(.Left, toEdge: .Left, ofView: startDateCalendarContainer, withOffset: 20)
        startDateCalendar.autoPinEdge(.Right, toEdge: .Right, ofView: startDateCalendarContainer, withOffset: -20)
        startDateCalendar.autoPinEdge(.Top, toEdge: .Top, ofView: startDateCalendarContainer, withOffset: 20)
        startDateCalendar.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: startDateCalendarContainer, withOffset: -20)
        startDateCalendar.monthLabel.textColor = darkColor
        startDateCalendar.hidden = true

        self.view.addSubview(changeEndDateButton)
        changeEndDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: eventName)
        changeEndDateButton.autoPinEdge(.Right, toEdge: .Right, ofView: eventName)
        changeEndDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateCalendarContainer, withOffset: 20)
        changeEndDateButton.backgroundColor = lightDarkColor
        changeEndDateButton.setTitle("TAP TO SET END DATE", forState: UIControlState.Normal)
        changeEndDateButton.setTitleColor(greenColor, forState: UIControlState.Normal)
        changeEndDateButton.addTarget(self, action: #selector(AddEventViewController.openEndDateCalendar(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(endDateCalendarContainer)
        endDateCalendarContainer.backgroundColor = blueColor
        endDateCalendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        endDateCalendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        endDateCalendarContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: changeEndDateButton)
        endDateCalendarContainer.autoSetDimension(.Height, toSize: 300)
        self.bottomOfEndDateCalendarView = endDateCalendarContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: changeEndDateButton)
        
        endDateCalendarContainer.addSubview(endDateCalendar)
        endDateCalendar.autoPinEdge(.Left, toEdge: .Left, ofView: endDateCalendarContainer, withOffset: 20)
        endDateCalendar.autoPinEdge(.Right, toEdge: .Right, ofView: endDateCalendarContainer, withOffset: -20)
        endDateCalendar.autoPinEdge(.Top, toEdge: .Top, ofView: endDateCalendarContainer, withOffset: 20)
        endDateCalendar.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: endDateCalendarContainer, withOffset: -20)
        endDateCalendar.monthLabel.textColor = darkColor
        endDateCalendar.hidden = true
        
        self.view.addSubview(searchMapButton)
        searchMapButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: endDateCalendarContainer, withOffset: 20)
        searchMapButton.autoPinEdge(.Right, toEdge: .Right, ofView: eventName)
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

    
    func openStartDateCalendar(sender: UIButton!){
        if(!startDateCalendarIsOpen){
            changeStartDateButton.setTitle(startDateCalendar.getFullCurrentDate(), forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.bottomOfStartDateCalendarView.active = false
                self.startDateCalendar.hidden = false
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    print("Animation completed")
                    self.startDateCalendarIsOpen = true
            })
        }
        else{
            changeStartDateButton.setTitle("TAP TO SET START DATE", forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.bottomOfStartDateCalendarView.active = true
                self.startDateCalendar.hidden = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    print("Animation completed")
                    self.startDateCalendarIsOpen = false
            })
        }
    }
    
    func openEndDateCalendar(sender: UIButton!){
        if(!endDateCalendarIsOpen){
            changeEndDateButton.setTitle(endDateCalendar.getFullCurrentDate(), forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.bottomOfEndDateCalendarView.active = false
                self.endDateCalendar.hidden = false
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    print("Animation completed")
                    self.endDateCalendarIsOpen = true
            })
        }
        else{
            changeEndDateButton.setTitle("TAP TO SET END DATE", forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.bottomOfEndDateCalendarView.active = true
                self.endDateCalendar.hidden = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    print("Animation completed")
                    self.endDateCalendarIsOpen = false
            })
        }
    }
}


