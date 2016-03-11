//
//  AddEventViewController.swift
//  LoCal
//
//  Created by Drew Roberts on 3/2/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    var backgroundColor = UIColor.whiteColor()
    var placeholderName : String!
    var nameOfEvent : String!

    let exitButtonConstraint = 
    
    let eventNameView = UIView()
    let locationMenu = UIView()
    let datePickerMenu = UIView()
    let date = UIDatePicker()
//    let startDateLabel = UILabel()
    let startTime = UITextView()
//    let endDateLabel = UILabel()
    let endTime = UITextView()
    let userEnterNameOfEvent = UITextField()
    let titleLabel = UILabel()

    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
        let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
        let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        let backgColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
        let addEventButtonColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
        let addLocationButtonColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
        let addEventContainer = UIView()
        let statusBar = UIView()

        //let header = ViewControllerHeader(title: "Add Event", imageFileName: "AddEventButtonPlus.png")

        let userLocation = UITextView()
        let startDateButton = UIButton()
        let endDate = UIDatePicker()
        let endDateButton = UIButton()
        let eventType = UIImageView()
        let exitButton = UIButton()
        let iconImageView = UIImageView()
        let headerLabel = UILabel()
        
        let addLocationButton = UIButton()
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerForKeyboardNotifications()
        
        self.view.addSubview(eventNameView)
        self.view.addSubview(statusBar)
        self.view.addSubview(addEventContainer)
        self.view.addSubview(titleLabel)
        self.view.addSubview(addLocationButton)
        self.view.addSubview(locationMenu)
        self.view.addSubview(userLocation)
        self.view.addSubview(datePickerMenu)
//        self.view.addSubview(startDateButton)
//        self.view.addSubview(startDateLabel)
        self.view.addSubview(startTime)
//        self.view.addSubview(endDateButton)
//        self.view.addSubview(endDateLabel)
        self.view.addSubview(endTime)
        
        eventNameView.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        eventNameView.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        eventNameView.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBar)
        eventNameView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        eventNameView.backgroundColor = backgColor
        self.view.bringSubviewToFront(eventNameView)
    
        addEventContainer.addSubview(exitButton)
        eventNameView.addSubview(exitButton)
        self.view.bringSubviewToFront(exitButton)
        let exitButtonImage = UIImage(named: "XButton.png")
        exitButton.setImage(exitButtonImage, forState: .Normal)
        exitButton.autoSetDimension(.Height, toSize: 50)
        exitButton.autoSetDimension(.Width, toSize: 50)
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: addEventContainer, withOffset: 10)
        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: addEventContainer, withOffset: 10)
        exitButton.addTarget(self, action: "onExit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        eventNameView.addSubview(userEnterNameOfEvent)
        userEnterNameOfEvent.delegate = self
        userEnterNameOfEvent.text = "Event Name"
        userEnterNameOfEvent.textColor = UIColor.whiteColor()
        userEnterNameOfEvent.textAlignment = .Center
        userEnterNameOfEvent.font = UIFont.systemFontOfSize(30)
        userEnterNameOfEvent.autoCenterInSuperview()
        userEnterNameOfEvent.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        userEnterNameOfEvent.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        userEnterNameOfEvent.addTarget(self, action: Selector("clearText:"), forControlEvents: UIControlEvents.EditingDidBegin)

        statusBar.backgroundColor = sidebColor
        statusBar.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBar.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBar.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBar.autoSetDimension(.Height, toSize: 20)
        
        
        addEventContainer.backgroundColor = backgColor
        addEventContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBar)
        addEventContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        addEventContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        addEventContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        
        titleLabel.text = nameOfEvent
        titleLabel.font = UIFont.systemFontOfSize(40)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.autoPinEdgeToSuperviewEdge(.Right)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left)
        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 100)
        
//        nameOfEventLabel.text = "Name your event"
//        nameOfEventLabel.font = UIFont.systemFontOfSize(20)
//        nameOfEventLabel.textColor = UIColor.whiteColor()
//        nameOfEventLabel.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 30)
//        nameOfEventLabel.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
//        nameOfEventLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 10)
        
        addLocationButton.backgroundColor = addLocationButtonColor
        addLocationButton.setTitle("Add Location", forState: .Normal)
        addLocationButton.autoMatchDimension(.Height, toDimension: .Height, ofView: titleLabel)
        addLocationButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 50)
        addLocationButton.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -50)
        addLocationButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 20)
        addLocationButton.addTarget(self, action: "onLocationButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
//        userLocation.delegate = self
//        userLocation.backgroundColor = UIColor.whiteColor()
//        userLocation.text = "Location"
//        userLocation.textColor = UIColor.lightGrayColor()
//        userLocation.font = UIFont.systemFontOfSize(20)
//        userLocation.autoSetDimension(.Height, toSize: 40)
//        userLocation.layer.cornerRadius = 5
//        userLocation.autoPinEdge(.Top, toEdge: .Bottom, ofView: userNameOfEvent, withOffset: 25)
//        userLocation.autoPinEdge(.Left, toEdge: .Right, ofView: addLocationButton, withOffset: 15)
//        userLocation.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -30)
        
        locationMenu.hidden = true
        locationMenu.backgroundColor = UIColor.blackColor()
        locationMenu.layer.borderColor = UIColor.grayColor().CGColor
        locationMenu.layer.borderWidth = 5
        locationMenu.layer.cornerRadius = 5
        locationMenu.autoPinEdge(.Top, toEdge: .Bottom, ofView: addLocationButton, withOffset: 5)
        locationMenu.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 15)
        locationMenu.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -15)
        locationMenu.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -15)
        
//        startDateButton.backgroundColor = UIColor.redColor()
//        startDateButton.autoMatchDimension(.Height, toDimension: .Height, ofView: addLocationButton)
//        startDateButton.autoMatchDimension(.Width, toDimension: .Width, ofView: addLocationButton)
//        startDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: addLocationButton, withOffset: 30)
//        startDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
//        startDateButton.addTarget(self, action: "onDateTap:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        endDateButton.backgroundColor = UIColor.yellowColor()
//        endDateButton.autoMatchDimension(.Height, toDimension: .Height, ofView: addLocationButton)
//        endDateButton.autoMatchDimension(.Width, toDimension: .Width, ofView: addLocationButton)
//        endDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateButton, withOffset: 30)
//        endDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
//        endDateButton.addTarget(self, action: "onDateTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
//        datePickerMenu.hidden = true
//        datePickerMenu.backgroundColor = UIColor.whiteColor()
//        datePickerMenu.layer.borderColor = UIColor.darkGrayColor().CGColor
//        datePickerMenu.layer.borderWidth = 5
//        datePickerMenu.layer.cornerRadius = 5
//        datePickerMenu.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateButton)
//        datePickerMenu.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
//        datePickerMenu.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        datePickerMenu.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        datePickerMenu.addSubview(date)
        
        date.minimumDate = NSDate()
        
        startTime.text = "No Start Time Selected"
        startTime.textColor = UIColor.lightGrayColor()
        startTime.backgroundColor = UIColor.whiteColor()
        startTime.layer.borderColor = UIColor.blackColor().CGColor
        startTime.layer.borderWidth = 1
        startTime.font = UIFont.systemFontOfSize(20)
        startTime.autoMatchDimension(.Height, toDimension: .Height, ofView: titleLabel)
        startTime.autoPinEdge(.Left, toEdge: .Left, ofView: self.view , withOffset: 15)
        startTime.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -15)
        startTime.autoPinEdge(.Top, toEdge: .Bottom, ofView: addLocationButton, withOffset: 30)
//        
//        startDateLabel.text = "No Start Date Selected"
//        startDateLabel.textColor = UIColor.whiteColor()
//        startDateLabel.font = UIFont.systemFontOfSize(20)
//        startDateLabel.autoPinEdge(.Left, toEdge: .Right, ofView: startDateButton, withOffset: 15)
//        startDateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: startTimeLabel, withOffset: 5)
        
        endTime.text = "No End Time Selected"
        endTime.textColor = UIColor.lightGrayColor()
        endTime.backgroundColor = UIColor.whiteColor()
        endTime.layer.borderColor = UIColor.blackColor().CGColor
        endTime.layer.borderWidth = 1
        endTime.font = UIFont.systemFontOfSize(20)
        endTime.autoMatchDimension(.Height, toDimension: .Height, ofView: titleLabel)
        endTime.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 15)
        endTime.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -15)
        endTime.autoPinEdge(.Top, toEdge: .Bottom, ofView: startTime)
        
//        endDateLabel.text = "No End Date Selected"
//        endDateLabel.textColor = UIColor.whiteColor()
//        endDateLabel.font = UIFont.systemFontOfSize(20)
//        endDateLabel.autoPinEdge(.Left, toEdge: .Right, ofView: endDateButton, withOffset: 15)
//        endDateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: endTimeLabel, withOffset: 5)
        

        
//        addEventContainer.addSubview(header)
//        header.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        header.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        header.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
//        header.autoSetDimension(.Height, toSize: 75)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: "UIKeyboardDidShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: "UIKeyboardWillHideNotification", object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.exitButtonConstraint.constant = -keyboardFrame.size.height
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: { finished in
        })
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.exitButtonConstraint.constant = 0
        })
    }
    
    func clearText(sender: UITextField!){
        userEnterNameOfEvent.text = ""
        print("clicked")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        eventNameView.hidden = true;
        eventNameView.endEditing(true)
        nameOfEvent = userEnterNameOfEvent.text
        titleLabel.text = nameOfEvent
        
        return true
    }
    
    func onLocationButtonTap(sender: UIButton!){
        if(locationMenu.hidden == true){
            locationMenu.hidden = false
            self.view.bringSubviewToFront(locationMenu)
        }
        else{
            locationMenu.hidden = true
        }
    }
    
    func onDateTap(sender: UIButton!){
        if(datePickerMenu.hidden == true){
            self.view.bringSubviewToFront(datePickerMenu)
            datePickerMenu.hidden = false
        }
        else{
            date.datePickerMode = UIDatePickerMode.DateAndTime
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
            let selectedDate = dateFormatter.stringFromDate(date.date)
            let selectedTime = timeFormatter.stringFromDate(date.date)
            startTime.text = selectedTime
//            startDateLabel.text = selectedDate
            datePickerMenu.hidden = true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if textView.textColor == UIColor.lightGrayColor() {
            placeholderName = textView.text
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView.text.isEmpty {
            textView.text = placeholderName
            textView.textColor = UIColor.lightGrayColor()
            
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func onExit(sender:UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
